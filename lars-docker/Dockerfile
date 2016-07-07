# (C) Copyright IBM Corporation 2016.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM websphere-liberty:kernel
ENV LICENSE accept

# Install and configure LARS
RUN installUtility install --acceptLicense cdi-1.0 jndi-1.0 appSecurity-2.0 ssl-1.0 mongodb-2.0 jaxrs-1.1 servlet-3.0
RUN wget -q https://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/wasdev/downloads/wlp/LARS/larsServerPackage.jar -O /tmp/larsServerPackage.jar \
    && java -jar /tmp/larsServerPackage.jar /opt/ibm \
    && rm /tmp/larsServerPackage.jar
COPY config.xml /opt/ibm/wlp/usr/servers/larsServer/configDropins/overrides/config.xml
CMD ["/opt/ibm/wlp/bin/server", "run", "larsServer"]

# Install LARS client
RUN wget -q https://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/wasdev/downloads/wlp/LARS/larsClient.zip -O /tmp/larsClient.zip \
    && unzip -d ~/larsClient /tmp/larsClient.zip \
    && rm /tmp/larsClient.zip
COPY populate /usr/local/bin/populate
