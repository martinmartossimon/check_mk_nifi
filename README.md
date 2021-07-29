# check_mk_nifi
Plugin for check_mk witch gets Apache NIFI system-diagnostics metrics and integrate them with check_mk.

# Required / Use:
- jq
- curl


# Metrics collected.
- heapUtilization
- availableProcessors
- processorLoadAverage
- totalThreads
- daemonThreads
- uptime
- flowFileRepositoryStorageUsage.utilization
- contentRepositoryStorageUsage[].utilization
- provenanceRepositoryStorageUsage[].utilization
Imagen1

# Parameters
URL_NIFI -> Points to /nifi-api/system-diagnostics URL.
HOST -> This is for diferenciate services names in case you run this plugin for several endpoints in the same host
UMBRAL_HEAP -> % Heap Utilization Threeshold
UMBRAL_DISK_UTILIZATION -> % Disk Utilization Threeshold for: flowFileRepositoryStorageUsage,contentRepositoryStorageUsage,provenanceRepositoryStorageUsage
MENSAJE_ESCALAR -> Custom plugin output in case of Critical State. Used for scallation.
Imagen2


# Output
