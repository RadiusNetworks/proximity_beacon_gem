module ProximityBeacon
  class Project < GoogleResource
    camelcase_attr_accessor :project_id, :project_number, :lifecycle_state, :name, :create_time

    alias_method :id, :project_id
    alias_method :id=, :project_id=
    alias_method :number, :project_number
    alias_method :number=, :project_number=

  end
end
