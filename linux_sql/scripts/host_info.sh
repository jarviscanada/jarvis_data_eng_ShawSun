# Setup and validate arguments (again, don't copy comments)
psql_host=$1
psql_port=$2
db_name=$3
psql_user=$4
psql_password=$5

# Check # of args
if [ "$#" -ne 5 ]; then
    echo "Illegal number of parameters"
    exit 1
fi

# Save machine statistics in MB and current machine hostname to variables
vmstat_mb=$(vmstat --unit M)
lscpu_out=$(lscpu)
hostname=$(hostname -f)

# Retrieve hardware specification variables
cpu_number=$(echo "$lscpu_out" | awk -F:  '/^CPU\(s\)/ {print $2}' | xargs)
cpu_architecture=$(echo "$lscpu_out" | egrep '^Architecture:' | awk '{print $2}' | xargs)
cpu_model=$(echo "$lscpu_out" | awk -F: '/^Model name/ {print $2}' | xargs)
cpu_mhz=$(echo "$lscpu_out" | awk -F: '/^Model name/ {print $2}' | grep -o '[0-9.]*GHz' | head -1 | sed 's/GHz//' | awk '{print $1*1000}')
l2_cache=$(echo "$lscpu_out" | awk -F: '/^L2 cache:/ {print $2}' | awk '{print $1}' | xargs)
total_mem=$(vmstat --unit M | tail -1 | awk '{print $4}')

# Current time in `2019-11-26 14:40:19` UTC format
timestamp=$(vmstat -t | tail -1 | awk '{print $(NF-1), $NF}') #todo

# Subquery to find matching id in host_info table
host_id="(SELECT id FROM host_name WHERE hostname='$hostname')";

# PSQL command: Inserts server usage data into host_usage table
# Note: be careful with double and single quotes
insert_stmt="INSERT INTO host_info(timestamp, hostname, cpu_number, cpu_architecture, cpu_model, cpu_mhz, l2_cache, total_mem) VALUES('$timestamp', '$hostname', '$cpu_number', '$cpu_architecture', '$cpu_model', '$cpu_mhz', '$l2_cache', '$total_mem')"

#set up env var for pql cmd
export PGPASSWORD=$psql_password

#Insert date into a database
psql -h $psql_host -p $psql_port -d $db_name -U $psql_user -c "$insert_stmt"
exit $?
