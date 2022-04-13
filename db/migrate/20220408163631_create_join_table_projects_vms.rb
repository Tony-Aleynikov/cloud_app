class CreateJoinTableProjectsVms < ActiveRecord::Migration[6.1]
  def change
    create_join_table :projects, :vms do |t|
      # t.index [:oproject_id, :vm_id]
      # t.index [:vm_id, :oproject_id]
    end
  end
end
