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

![Metrics](https://github.com/martinmartossimon/check_mk_nifi/blob/main/images/check_mk_NIFI_1.png)

# Parameters
- __URL_NIFI__ -> Points to /nifi-api/system-diagnostics URL.
- __HOST__ -> This is for diferenciate services names in case you run this plugin for several endpoints in the same host
- __UMBRAL_HEAP__ -> % Heap Utilization Threeshold
- __UMBRAL_DISK_UTILIZATION__ -> % Disk Utilization Threeshold for: flowFileRepositoryStorageUsage,contentRepositoryStorageUsage,provenanceRepositoryStorageUsage
- __MENSAJE_ESCALAR__ -> Custom plugin output in case of Critical State. Used for scallation.
![Parameters](https://github.com/martinmartossimon/check_mk_nifi/blob/main/images/check_mk_NIFI_2.png)

# Output
![Metrics](https://github.com/martinmartossimon/check_mk_nifi/blob/main/images/check_mk_NIFI_3.png)
![Metrics](https://github.com/martinmartossimon/check_mk_nifi/blob/main/images/check_mk_NIFI_4.png)
![Metrics](https://github.com/martinmartossimon/check_mk_nifi/blob/main/images/check_mk_NIFI_5.png)
![Metrics](https://github.com/martinmartossimon/check_mk_nifi/blob/main/images/check_mk_NIFI_6.png)
![Metrics](https://github.com/martinmartossimon/check_mk_nifi/blob/main/images/check_mk_NIFI_7.png)
