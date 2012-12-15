# RailsAdmin config file. Generated on May 19, 2012 22:52
# See github.com/sferik/rails_admin for more informations

RailsAdmin.config do |config|

  # If your default_local is different from :en, uncomment the following 2 lines and set your default locale here:
  # require 'i18n'
  # I18n.default_locale = :de

  config.current_user_method { current_member } # auto-generated
  config.authorize_with do
		unless current_member.admin?
		  redirect_to "/"
	  end
  end
  # If you want to track changes on your models:
  # config.audit_with :history, User

  # Or with a PaperTrail: (you need to install it first)
  # config.audit_with :paper_trail, User

  # Set the admin name here (optional second array element will appear in a beautiful RailsAdmin red ©)
  config.main_app_name = ['Veggie', 'Admin']
  # or for a dynamic name:
  # config.main_app_name = Proc.new { |controller| [Rails.application.engine_name.titleize, controller.params['action'].titleize] }


  #  ==> Global show view settings
  # Display empty fields in show views
  # config.compact_show_view = false

  #  ==> Global list view settings
  # Number of default rows per-page:
  # config.default_items_per_page = 20

  #  ==> Included models
  # Add all excluded models here:
  config.excluded_models = [RWord]

  # Add models here if you want to go 'whitelist mode':
  # config.included_models = [Leaf, Provider]

  # Application wide tried label methods for models' instances
  # config.label_methods << :description # Default is [:name, :title]
  
  #  ==> Global models configuration
  # config.models do
  #   # Configuration here will affect all included models in all scopes, handle with care!
  #
  #   list do
  #     # Configuration here will affect all included models in list sections (same for show, export, edit, update, create)
  #
  #     fields_of_type :date do
  #       # Configuration here will affect all date fields, in the list section, for all included models. See README for a comprehensive type list.
  #     end
  #   end
  # end
  #
  #  ==> Model specific configuration
  # Keep in mind that *all* configuration blocks are optional.
  # RailsAdmin will try his best to provide the best defaults for each section, for each field.
  # Try to override as few things as possible, in the most generic way. Try to avoid setting labels for models and attributes, use ActiveRecord I18n API instead.
  # Less code is better code!
  # config.model MyModel do
  #   # Cross-section field configuration
  #   object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #   label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #   label_plural 'My models'      # Same, plural
  #   weight -1                     # Navigation priority. Bigger is higher.
  #   parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #   navigation_label              # Sets dropdown entry's name in navigation. Only for parents!
  #   # Section specific configuration:
  #   list do
  #     filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #     items_per_page 100    # Override default_items_per_page
  #     sort_by :id           # Sort column (default is primary key)
  #     sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     # Here goes the fields configuration for the list view
  #   end
  # end
  config.model Member do
    list  do
      fields :id,:uid,:current_sign_in_ip,:sign_in_count,:current_sign_in_at
      field :email do
        label "Avatar"
        pretty_value do
          bindings[:view].image_tag(bindings[:object].avatar)
        end
        column_width 55
      end
    end
  end
  config.model Provider do
    list do
      fields :id,:provider,:uid,:created_at
      field :metadata do
        label "Info"
        pretty_value do
          value[:name] ? value[:name] : value[:nickname]
        end
      end
    end
  end
  config.model Leaf do
    list do
      fields :id,:content,:time_stamp,:weibo_id
      field :provider do
        pretty_value do
          bindings[:view].link_to("weibo",bindings[:object].provider.weibo)
        end
      end
      field :image_url do
        pretty_value do
          value.nil? ? "-" : bindings[:view].image_tag(bindings[:object].image(:thumb))
        end
      end
    end
  end

  # Your model's configuration, to help you get started:

  # All fields marked as 'hidden' won't be shown anywhere in the rails_admin unless you mark them as visible. (visible(true))

  # config.model Leaf do
  #   # Found associations:
  #     configure :provider, :belongs_to_association   #   # Found columns:
  #     configure :id, :integer 
  #     configure :content, :text 
  #     configure :provider_id, :integer         # Hidden 
  #     configure :image_url, :string 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :time_stamp, :datetime   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Provider do
  #   # Found associations:
  #     configure :leafs, :has_many_association   #   # Found columns:
  #     configure :id, :integer 
  #     configure :provider, :string 
  #     configure :uid, :string 
  #     configure :token, :string 
  #     configure :secret, :string 
  #     configure :user_id, :integer 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
end
