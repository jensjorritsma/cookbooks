
#
# Remote Desktop Server 
#

package "python-software-properties"

bash "install_freenx" do
  code <<-EOH
  add-apt-repository ppa:freenx-team
  apt-get update
  EOH
end

package "freenx"

package "ubuntu-desktop"
