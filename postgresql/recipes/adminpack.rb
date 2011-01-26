
#
# Add postgres contrib package
#

require_recipe "postgresql::server"

package "postgresql-contrib-#{node.postgresql.version}"

execute "psql" do
  user "postgres"
  command "su - postgres -c 'psql < /usr/share/postgresql/#{node.postgresql.version}/contrib/adminpack.sql'"
end

service "postgresql" do
  service_name "postgresql-#{node.postgresql.version}"
  action :restart
end
