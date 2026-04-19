# Setup and validate arguments
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
hostname=$(hostname -f)

# Retrieve hardware specification variabels
memory_free=$(echo "$vmstat_mb" | awk '{print $4}' | tail -n1 | xargs)
cpu_idle=$(echo "$vmstat_mb" | tail -1 | awk '{print $(NF-2)}') #todo
cpu_kernel=$(echo "$vmstat_mb" | tail -1 | awk '{print $(NF-3)}') #todo
disk_io=$(vmstat -d | tail -1 | awk -v col="10" '{print $col}') #todo
disk_available=$(df -BM | egrep '^/dev/sda2' | awk '{print $4}' | sed 's/M//') 

# current time in UTC format
timestamp=$(vmstat -t | tail -1 | awk '{print $(NF-1), $NF}') #todo

# Subquery to find matching id in host_info table
host_id="(SELECT id FROM host _info WHERE hostname='$hostname')";

# PSQL command: Inserts server usage data into host_usage table
insert_stmt="INSERT INTO host_usage(timestamp, memory_free, cpu_idle, cpu_kernel, disk_io, disk_available) VALUES('$timestamp', '$memory_free', '$cpu_idle', '$cpu_kernel', '$disk_io', '$disk_available')" # todo...

# set up env var for psql cmd
export PGPASSWORD=$psql_password

# Insert date into a database
psql -h $psql_host -p $psql_port -d $db_name -U $psql_user -c "$insert_stmt"
exit $?
