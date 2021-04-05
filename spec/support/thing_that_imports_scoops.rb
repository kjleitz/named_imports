from 'scoops', import { Scoops }

class ThingThatImportsScoops
  def self.scoops_class_counter
    Scoops.class_counter
  end

  def self.scoops_class_instance_counter
    Scoops.class_instance_counter
  end

  def self.increment_scoops_class_counter!
    Scoops.increment_class_counter!
  end

  def self.reset_scoops_class_counter!
    Scoops.reset_class_counter!
  end

  def self.increment_scoops_class_instance_counter!
    Scoops.increment_class_instance_counter!
  end

  def self.reset_scoops_class_instance_counter!
    Scoops.reset_class_instance_counter!
  end
end
