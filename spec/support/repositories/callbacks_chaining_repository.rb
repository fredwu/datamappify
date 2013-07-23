class CallbacksChainingRepository
  include Datamappify::Repository

  for_entity HeroUser
  default_provider :ActiveRecord

  map_attribute :first_name, :to => 'HeroUser#first_name'
  map_attribute :last_name,  :to => 'HeroUserLastName#last_name', :provider => :Sequel
  map_attribute :gender,     :to => 'HeroUserLastName#gender',    :provider => :Sequel

  before_save   :before_save_1
  before_save   :before_save_2
  before_save   :before_save_3
  before_create :before_create_1
  before_create :before_create_2
  after_save    :after_save_1
  after_save    :after_save_2
  after_save    :after_save_3

  private

  def before_save_1  (entity); performed(:before_save_1,   entity); true; end
  def before_save_2  (entity); performed(:before_save_2,   entity); true; end
  def before_save_3  (entity); performed(:before_save_3,   entity); true; end
  def before_create_1(entity); performed(:before_create_1, entity); true; end
  def before_create_2(entity); performed(:before_create_2, entity); true; end
  def after_save_1   (entity); performed(:after_save_1,    entity); true; end
  def after_save_2   (entity); performed(:after_save_2,    entity); true; end
  def after_save_3   (entity); performed(:after_save_3,    entity); true; end

  def performed(*args)
    true
  end
end

class CallbacksChainingPauseBeforeRepository
  include Datamappify::Repository

  for_entity HeroUser
  default_provider :ActiveRecord

  map_attribute :first_name, :to => 'HeroUser#first_name'
  map_attribute :last_name,  :to => 'HeroUserLastName#last_name', :provider => :Sequel
  map_attribute :gender,     :to => 'HeroUserLastName#gender',    :provider => :Sequel

  before_save   :before_save_1
  before_save   :before_save_2
  before_save   :before_save_3
  before_create :before_create_1
  before_create :before_create_2
  after_save    :after_save_1
  after_save    :after_save_2
  after_save    :after_save_3

  private

  def before_save_1  (entity); performed(:before_save_1,   entity); true;  end
  def before_save_2  (entity); performed(:before_save_2,   entity); false; end
  def before_save_3  (entity); performed(:before_save_3,   entity); true;  end
  def before_create_1(entity); performed(:before_create_1, entity); true;  end
  def before_create_2(entity); performed(:before_create_2, entity); true;  end
  def after_save_1   (entity); performed(:after_save_1,    entity); true;  end
  def after_save_2   (entity); performed(:after_save_2,    entity); true;  end
  def after_save_3   (entity); performed(:after_save_3,    entity); true;  end

  def performed(*args)
    true
  end
end

class CallbacksChainingPauseAfterRepository
  include Datamappify::Repository

  for_entity HeroUser
  default_provider :ActiveRecord

  map_attribute :first_name, :to => 'HeroUser#first_name'
  map_attribute :last_name,  :to => 'HeroUserLastName#last_name', :provider => :Sequel
  map_attribute :gender,     :to => 'HeroUserLastName#gender',    :provider => :Sequel

  before_save   :before_save_1
  before_save   :before_save_2
  before_save   :before_save_3
  before_create :before_create_1
  before_create :before_create_2
  after_save    :after_save_1
  after_save    :after_save_2
  after_save    :after_save_3

  private

  def before_save_1  (entity); performed(:before_save_1,   entity); true;  end
  def before_save_2  (entity); performed(:before_save_2,   entity); true;  end
  def before_save_3  (entity); performed(:before_save_3,   entity); true;  end
  def before_create_1(entity); performed(:before_create_1, entity); true;  end
  def before_create_2(entity); performed(:before_create_2, entity); true;  end
  def after_save_1   (entity); performed(:after_save_1,    entity); true;  end
  def after_save_2   (entity); performed(:after_save_2,    entity); false; end
  def after_save_3   (entity); performed(:after_save_3,    entity); true;  end

  def performed(*args)
    true
  end
end
