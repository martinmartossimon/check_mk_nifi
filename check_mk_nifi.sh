#!/bin/bash

#################################################################################################################
# Titulo:
#
# Descripcion:
#
# Detalle:
# COMANDO COLECTOR: 
#
# Autor: Martin Martos Simon - martinmartossimon@gmail.com
# MIT License
# 
# Copyright (c) 2020 Martin Martos Simon - martinmartossimon@gmail.com
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# #
#################################################################################################################

########################## DEBUG
#set -x

########################## PARAMETRIZACION
URL_NIFI="http://172.17.53.34:8080/nifi-api/system-diagnostics"
HOST="172.17.53.34"

UMBRAL_HEAP=90
UMBRAL_DISK_UTILIZATION=80

MENSAJE_ESCALAR="Favor escalar esta alarma con el equipo NIFI"


########################## FUNCIONES



########################## MAIN
FECHA_CHEQUEO=$(date)
TSTART=$(($(date +%s%N)/1000000))
JSON=$(timeout 20 curl -sS $URL_NIFI 2>/dev/null)
CODSAL=$?
TEND=$(($(date +%s%N)/1000000))
RUNTIME=$((TEND-TSTART))
RUNTIMEMS=$(echo "$RUNTIME 1000" | awk -v CONVFMT='%.1f' '{print $1/$2}')

if [[ $CODSAL -eq "0" ]]; then
	echo "0 Comando_Chequeo_Apache_Nifi_$HOST texec=$RUNTIMEMS;;|codSal=$CODSAL;; OK - Comando de chequeo de apache NIFI se ejecuto correctamente. Fecha: $FECHA_CHEQUEO. Tiempo de ejecucion: $RUNTIMEMS ms. Cod de salida: $CODSAL. URL chequeada: $URL_NIFI"
	
	#Empiezo a chequear cada uno de los servicios.
	HEAP_UTILIZATION=$(echo "$JSON" | jq -r '.systemDiagnostics.aggregateSnapshot.heapUtilization' | sed 's/%//')
	#echo "$HEAP_UTILIZATION"
	if (( $(echo "$HEAP_UTILIZATION > $UMBRAL_HEAP" | bc -l) )); then
		#echo "error"
		echo "2 NFI_HEAP_UTILIZATION_$HOST heapUtilization=$HEAP_UTILIZATION;; Alarma Critica. El uso de Heap: $HEAP_UTILIZATION esta por encima del umbral configurado: $UMBRAL_HEAP. $MENSAJE_ESCALAR"
	else
		#echo "heap OK"
		echo "0 NFI_HEAP_UTILIZATION_$HOST heapUtilization=$HEAP_UTILIZATION;; Ok. El uso de Heap: $HEAP_UTILIZATION esta por debajo del umbral configurado: $UMBRAL_HEAP."
	fi

	FLOWFILEREPOSITORYSTORAGEUSAGE=$(echo "$JSON" | jq -r '.systemDiagnostics.aggregateSnapshot.flowFileRepositoryStorageUsage.utilization' | sed 's/%//')
	#echo "flowFileRepositoryStorageUsage=$FLOWFILEREPOSITORYSTORAGEUSAGE"
	if (( $(echo "$FLOWFILEREPOSITORYSTORAGEUSAGE > $UMBRAL_DISK_UTILIZATION" | bc -l) )); then
		#echo "error"
		echo "2 NFI_flowFileRepositoryStorageUsage_$HOST diskUtilization=$FLOWFILEREPOSITORYSTORAGEUSAGE;; Alarma Critica. El uso de flowFileRepositoryStorageUsage: $FLOWFILEREPOSITORYSTORAGEUSAGE esta por encima del umbral configurado: $UMBRAL_DISK_UTILIZATION. $MENSAJE_ESCALAR"
	else
		#echo "flowFileRepositoryStorageUsage OK"
		echo "0 NFI_flowFileRepositoryStorageUsage_$HOST diskUtilization=$FLOWFILEREPOSITORYSTORAGEUSAGE;; OK. El uso de flowFileRepositoryStorageUsage: $FLOWFILEREPOSITORYSTORAGEUSAGE esta por debajo del umbral configurado: $UMBRAL_DISK_UTILIZATION."
	fi

	#Este devuelve un array, por lo que tengo que procesar linea por linea
	CONTENTREPOSITORYSTORAGEUSAGE=$(echo "$JSON" | jq -r '.systemDiagnostics.aggregateSnapshot.contentRepositoryStorageUsage[] | [.identifier, .utilization] | @csv' | sed 's/"//g' | sed 's/%//' )
	#echo "contentRepositoryStorageUsage"
	#echo "$CONTENTREPOSITORYSTORAGEUSAGE"
	for linea in $CONTENTREPOSITORYSTORAGEUSAGE; do
		#echo "Procesando Linea: $linea"
		ID=$(echo $linea | awk -F',' '{print $1}')
		VALOR=$(echo $linea | awk -F',' '{print $2}')
		#echo "$ID|$VALOR"
		if (( $(echo "$VALOR > $UMBRAL_DISK_UTILIZATION" | bc -l) )); then
			#echo "Error"
			echo "2 NFI_contentRepositoryStorageUsage_${ID}_$HOST diskUtilization=$VALOR;; Alarma Critica. El contentRepositoryStorageUsage con id: $ID es de: $VALOR esta por encima del umbral configurado: $UMBRAL_DISK_UTILIZATION. $MENSAJE_ESCALAR"
		else
			#echo "OK"
			echo "0 NFI_contentRepositoryStorageUsage_${ID}_$HOST diskUtilization=$VALOR;; OK. El contentRepositoryStorageUsage de $ID es de: $VALOR esta por debajo del umbral configurado: $UMBRAL_DISK_UTILIZATION."
		fi
	done

	#Este devuelve un array, por lo que tengo que procesar linea por linea
	PROVENANCEREPOSITORYSTORAGEUSAGE=$(echo "$JSON" | jq -r '.systemDiagnostics.aggregateSnapshot.provenanceRepositoryStorageUsage[] | [.identifier, .utilization] | @csv ' | sed 's/"//g' | sed 's/%//')
	#echo "provenanceRepositoryStorageUsage"
        #echo "$PROVENANCEREPOSITORYSTORAGEUSAGE"
        for linea in $PROVENANCEREPOSITORYSTORAGEUSAGE; do
                #echo "Procesando Linea: $linea"
                ID=$(echo $linea | awk -F',' '{print $1}')
                VALOR=$(echo $linea | awk -F',' '{print $2}')
                #echo "$ID|$VALOR"
                if (( $(echo "$VALOR > $UMBRAL_DISK_UTILIZATION" | bc -l) )); then
                        #echo "Error"
			echo "2 NFI_provenanceRepositoryStorageUsage_${ID}_$HOST diskUtilization=$VALOR;; Alarma Critica. El provenanceRepositoryStorageUsage con id: $ID es de: $VALOR esta por encima del umbral configurado: $UMBRAL_DISK_UTILIZATION. $MENSAJE_ESCALAR"
                else
                        #echo "OK"
			echo "0 NFI_provenanceRepositoryStorageUsage_${ID}_$HOST diskUtilization=$VALOR;; OK. El provenanceRepositoryStorageUsage de $ID es de: $VALOR esta por debajo del umbral configurado: $UMBRAL_DISK_UTILIZATION."
                fi
        done

	#Otras metricas extra no solicitadas y sin umbrales, solo para graficas
	AVAILABLEPROCESSORS=$(echo $JSON | jq -r '.systemDiagnostics.aggregateSnapshot.availableProcessors')
	PROCESSORLOADAVERAGE=$(echo $JSON | jq -r '.systemDiagnostics.aggregateSnapshot.processorLoadAverage')
	TOTALTHREADS=$(echo $JSON | jq -r '.systemDiagnostics.aggregateSnapshot.totalThreads')
	DAEMONTHREADS=$(echo $JSON | jq -r '.systemDiagnostics.aggregateSnapshot.daemonThreads')
	UPTIME=$(echo $JSON | jq -r '.systemDiagnostics.aggregateSnapshot.uptime')

	echo "0 NIFI_CPU_$HOST availableProcessors=$AVAILABLEPROCESSORS;;|processorLoadAverage=$PROCESSORLOADAVERAGE;;|totalThreads=$TOTALTHREADS;;|daemonThreads=$DAEMONTHREADS;; El servicio esta UP desde $UPTIME. Metricas actuales availableProcessors=$AVAILABLEPROCESSORS|processorLoadAverage=$PROCESSORLOADAVERAGE|totalThreads=$TOTALTHREADS|daemonThreads=$DAEMONTHREADS"

else
	#echo "falla la consulta a la URL"
	echo "2 Comando_Chequeo_Apache_Nifi_$HOST texec=$RUNTIMEMS;;|codSal=$CODSAL;; OK - Comando de chequeo de apache NIFI se ejecuto correctamente. Fecha: $FECHA_CHEQUEO. Tiempo de ejecucion: $RUNTIMEMS ms. Cod de salida: $CODSAL. URL chequeada: $URL_NIFI. $MENSAJE_ESCALAR"
fi

