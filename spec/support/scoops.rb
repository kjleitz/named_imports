class Scoops
  @@class_counter = 0
  @class_instance_counter = 0

  def self.class_counter
    @@class_counter
  end

  def self.class_instance_counter
    @class_instance_counter
  end

  def self.increment_class_counter!
    @@class_counter += 1
  end

  def self.reset_class_counter!
    @@class_counter = 0
  end

  def self.increment_class_instance_counter!
    @class_instance_counter += 1
  end

  def self.reset_class_instance_counter!
    @class_instance_counter = 0
  end
end
