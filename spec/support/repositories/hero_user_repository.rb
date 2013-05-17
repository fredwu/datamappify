class HeroUserRepository
  include Datamappify::Repository

  for_entity HeroUser
  default_provider :ActiveRecord

  map_attribute :first_name, 'ActiveRecord::HeroUser#first_name'
  map_attribute :last_name,  'Sequel::HeroUserLastName#last_name'
  map_attribute :gender,     'Sequel::HeroUserLastName#gender'

  before_create  :action_before_create
  before_create  :action_before_create2
  before_update  :action_before_update
  before_save    :action_before_save
  before_destroy :action_before_destroy

  after_create   :action_after_create
  after_update   :action_after_update
  after_save     :action_after_save
  after_destroy  :action_after_destroy

  private

  def action_before_create  (entity); performed(:before_create,  entity); end
  def action_before_create2 (entity); performed(:before_create2, entity); end
  def action_before_update  (entity); performed(:before_update,  entity); end
  def action_before_save    (entity); performed(:before_save,    entity); end
  def action_before_destroy (entity); performed(:before_destroy, entity); end

  def action_after_create   (entity); performed(:after_create,   entity); end
  def action_after_update   (entity); performed(:after_update,   entity); end
  def action_after_save     (entity); performed(:after_save,     entity); end
  def action_after_destroy  (entity); performed(:after_destroy,  entity); end

  def performed(*args)
    true
  end
end
