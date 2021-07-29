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
- __URL_NIFI__ -> Points to /nifi-api/system-diagnostics URL.
- __HOST__ -> This is for diferenciate services names in case you run this plugin for several endpoints in the same host
- __UMBRAL_HEAP__ -> % Heap Utilization Threeshold
- __UMBRAL_DISK_UTILIZATION__ -> % Disk Utilization Threeshold for: flowFileRepositoryStorageUsage,contentRepositoryStorageUsage,provenanceRepositoryStorageUsage
- __MENSAJE_ESCALAR__ -> Custom plugin output in case of Critical State. Used for scallation.
Imagen2


# Output
