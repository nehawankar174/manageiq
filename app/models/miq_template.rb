class MiqTemplate < VmOrTemplate
  include CustomActionsMixin

  default_scope { where(:template => true) }

  include_concern 'Operations'

  def self.base_model
    MiqTemplate
  end

  def self.corresponding_model
    parent::Vm
  end
  class << self; alias_method :corresponding_vm_model, :corresponding_model; end

  delegate :corresponding_model, :to => :class
  alias_method :corresponding_vm_model, :corresponding_model

  def scan_via_ems?
    true
  end

  def self.supports_kickstart_provisioning?
    false
  end

  delegate :supports_kickstart_provisioning?, :to => :class

  def self.eligible_for_provisioning
    where(arel_table[:ems_id].not_eq(nil))
  end

  def self.without_volume_templates
    where.not(:type => ["ManageIQ::Providers::Openstack::CloudManager::VolumeTemplate",
                        "ManageIQ::Providers::Openstack::CloudManager::VolumeSnapshotTemplate",
                        "ManageIQ::Providers::Telefonica::CloudManager::VolumeTemplate",
                        "ManageIQ::Providers::Telefonica::CloudManager::VolumeSnapshotTemplate"])
  end

  def active?; false; end

  def self.display_name(number = 1)
    n_('Template and Image', 'Templates and Images', number)
  end
end
