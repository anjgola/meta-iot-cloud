DESCRIPTION = "Python Client for Google BigQuery"

PV = "0.22.1"
PR = "r0"

RDEPENDS_${PN} += "\
	${PYTHON_PN}-google-cloud-core \
"

SRC_DIR = "bigquery"