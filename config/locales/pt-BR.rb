{
  :'pt-BR' => {

    # will_paginate
    :previous => "Anterior",
    :next     => "Próximo",

    :date => {
      :formats => {
        :long_ordinal => lambda { |date| "%B #{date.day.ordinalize}, %Y" },
        :long => lambda { |date| "%B #{date.day.ordinalize}, %Y" }
      }
    },
    :time => {
      :formats => {
        :long_ordinal => lambda { |time| "%B #{time.day.ordinalize}, %Y %H:%M" }
      },
      :time_with_zone => {
        :formats => {
          :default => lambda { |time| "%Y-%m-%d %H:%M:%S #{time.formatted_offset(false, 'UTC')}" }
        }
      },
      :am => 'am',
      :pm => 'pm'
    },
    # date helper distance in words
    #NOTE: Pluralization rules have changed! Rather than simply submitting an array, i18n now allows for a hash with the keys:
    # :zero, :one & :other   - FUNKY (but a pain to find...)!
    :datetime => {
      :distance_in_words => {
        :half_a_minute       => 'half a minute',
        :less_than_x_seconds => {:zero => 'less than 1 second', :one => '1 second', :other => '{{count}} seconds'},
        :x_seconds           => {:one => '1 second', :other => '{{count}} seconds'},
        :less_than_x_minutes => {:zero => 'less than a minute', :one => '1 minute', :other => '{{count}} minutes'},
        :x_minutes           => {:one => "1 minute", :other => "{{count}} minutes"},
        :about_x_hours       => {:one => 'about 1 hour', :other => '{{count}} hours'},
        :x_days              => {:one => '1 day', :other => '{{count}} days'},
        :about_x_months      => {:one => 'about 1 month', :other => '{{count}} months'},
        :x_months            => {:one => '1 month', :other => '{{count}} months'},
        :about_x_years       => {:one => 'about 1 year', :other => '{{count}} years'},
        :over_x_years        => {:one => 'over 1 year', :other => '{{count}} years'}
      }
    },

    # numbers
    :number => {
      :format => {
        :precision => 3,
        :separator => ',',
        :delimiter => '.'
      },
      :currency => {
        :format => {
          :unit => '$',
          :precision => 2,
          :format => '%u %n'
        }
      }
    },

    # Active Record
    :activerecord => {
      :models     => {
        :user         => "usuário",
      },
      :attributes => {
        :user   => {
          :login    => "Nome de Usuário",
          :password => "Senha",
          :password_confirmation => "Confirmação de Senha",
          },
      },
    },
    :txt => {
      :main_title => "Localizing Rails",
      :beast_title => "tectura.com.br",
      :app_name => "tectura.com.br",
      :sub_title => "how to localize your app with Rails' new i18n features",
      :contents => "Contents",
      :menu => {
        :introduction => "Introduction",
        :about => "About",
        :setup => "Setup",
        :date_formats => "Date formats",
        :time_formats => "Time formats"
      },
      :about => {
        :title => "About this demo app",
        :author => "This demo app was written by {{mail_1}}.",
        :feedback => "If you have any feedback, please feel free to drop me a line. Also visit {{blog_href}} where I regularly blog about Rails and other stuff.",
        :licence => "This demo app and all its contents are licensed under the {{licence_href}}. If you want to use it in ways prohibited by this license, please contact me and ask my permission."
      },
      :active_record => {
        :too_lazy => "No examples here since I'm too lazy to think of attributes to show <strong>all</strong> custom error messages. ;-)",
        :easy_to_understand => "It's quite easy to understand, though."
      },
      :date_formats => {
        :rails_standards_work => "Rails standard formats (Date::DATE_FORMATS) still work:"
      },
      :date_helper => {
        :date_time_title => "Date/Time distance",
        :forms_title => "Forms"
      },
      :index => {
        :others => "others",
        :introduction => "Lately, a lot of work has been done by {{sven_blog}} and {{sven_github}} to facilitate future internationalization and localization of Rails.",
        :story_so_far => "This demo app tries to show you how you can use the features that have been implemented so far to localize big parts of your Rails application."
      },
      :number_helper => {
        :note_one => "Note: <code>number_to_phone</code> hasn't been localized yet and probably never will be - at least not in core. Look out for new internationalization/localization plugins like a new version of {{globalize}} as they will probably support stuff like that.",
        :note_two => "Another note: <code>number_to_currency</code>, <code>number_to_percentage</code> and <code>number_to_human_size</code> all use <code>number_with_precision</code> internally and <code>number_with_precision</code> uses <code>number_with_delimiter</code> internally."
      },
      :setup => {
        :freezing_edge_and_adding => "Freezing Edge and installing the localized_dates plugin",
        :you_need_to_be_on_edge => "You need to be on Edge Rails in order to use the Rails i18n features:",
        :date_time_formats => "For date and time formats, you also need to install the {{localized_dates_link}}:",
        :config_locale => "Configuring the locale",
        :best_place => "The best place to put your locale configuration, in my opinion, is <code>config/locales</code>. The localized_dates plugin will copy two locales, en-US and de-AT, in this directory. You can extend or modify them and also create new locales.",
        :locale => "Here's the demo locale that was used for this demo application:",
        :defaults => "You also need to set up the default locale and/or locale in your <code>environment.rb</code> or an initializer.",
        :locale_structure_title => "A word on the structure of locales",
        :locale_structure_number => "You may have noticed that inside the <code>:number</code> part of the locale, we defined <code>:format</code> and <code>:currency</code>. In general, locales are structured hierarchically - i.e. a currencies are numbers, percentages are numbers, etc. <code>:currency</code> can either override the basic <code>:format</code> settings (in our case, we set <code>:precision</code> to 2 instead of 3) or extend them (we add two new options, <code>:unit</code> and <code>:format</code>).",
        :locale_structure_date_time => "The same holds true for dates and times: If needed, <code>:datetime</code> and <code>:time_with_zone</code> can be used to specifically address formatting of their respective types instead of just relying on the settings for <code>:time</code>. Note, however, that usually you want to use the same formats as <code>:time</code>."
      },
      :time_formats => {
        :rails_standards_work => "Rails standard formats (Time::DATE_FORMATS) still work:"
      },
      :ipe => {
        :click => "click here!"
      },

      ##### LOCALIZAÇÃO #####

      # Header
      :forums   => "Fóruns",
      :users    => "Usuários",
      :settings => "Preferências",
      :logout   => "Sair",
      :signup   => "Cadastro",
      :login    => "Login",
      :or       => " | ",
      :save     => "Salvar",
      :home     => "Início",

      # Forum
      :footer_message => "Copyright © 2010 <a href=\"http://www.caelum.com.br\">Caelum</a>",
      :created_by     => "código criado por",
      :moderator      => "Moderador",
      :count_topics   => {:one => "<span class=\"bignum\">1</span> discussão", :other => "<span class=\"bignum\">{{count}}</span> discussões"},
      :count_posts    => {:one => "<span class=\"bignum\">1</span> mensagem", :other => "<span class=\"bignum\">{{count}}</span> mensagens"},
      :my_topics      => "Minhas discussões",
      :new_topic      => "Nova discussão",
      :post_age       => "Há {{when}}",
      :by_user        => "por {{user}}",
      :view           => "ler",
      :views_forums   => {
        :unmoderated  => "Este fórum não é moderado."
      },

      # Session
      :cancel               => "Cancelar",
      :login_name           => "Usuário",
      :login_name_signup    => "Login / Nome do Usuário (Nome Sobrenome)",
      :state                => "Estado",
      :city                 => "Cidade",
      :password             => "Senha",
      :log_in               => "Entrar",
      :remember_me          => "Lembrar de mim",
      :or_login_with_openid => "Entre pelo OpenID",
      :successful_login     => "Login feito com sucesso",
      :logged_out           => "Logout feito com sucesso",
      :invalid_login        => "Usuário ou senha incorreta",
      :email_not_found      => "Este email não está cadastrado",

      # Topics
      :author           => "Autor",
      :score            => "Pontos",
      :sticky           => "fixo",
      :locked           => "trancado",
      :post_topic       => "Criar discussão",
      :monitor_topic    => "Monitorar discussão",
      :monitoring_topic => "Monitorando discussão",
      :count_voices     => {:one => "1 participante", :other => "{{count}} participantes"},
      :voices           => "Participantes",
      :reply_to_topic   => "Responder",
      :save_changes     => "Salvar alterações",
      :edit             => "Editar",
      :delete           => "Apagar",
      :goto_last_page   => "última página",
      :posts            => "Mensagens",
      :views            => "Visualizações",
      :latest_post      => "Movimentação",
      :set              => "Definir",
      :topic_created    => "Tópico criado com sucesso",
      :topic_updated    => "Tópico modificado com sucesso",
      :views_topics => {
        :topic        => "Título",
        :body         => "Texto",
        :save_reply   => "Responder",
        :delete_sure  => "Esta discussão será apagada.",
      },
      :post_topic_and_login => "Logar e postar",
      :post_topic_and_create_user => "Cadastrar e postar",
      :not_signedup => "Não cadastrado",

      # Email
      :account_has_been_created   => "Sua conta foi criada com sucesso.",
      :account_has_been_activated => "Sua conta foi ativada com sucesso.",
      :reset_your_password        => "Clique no link abaixo para definir uma nova senha.",
      :visit_url_to_activate      => "Visite este link para ativar sua conta",
      :subject_activate           => "Ative sua conta",
      :subject_activated          => "Sua conta foi ativada",
      :request_to_change_your_password => "Mudança de senha",
      :username                   => "Usuário",
      :password                   => "Senha",
      :verify_your_email          => "Verifique seu email para mudar sua senha",
      :mail_sent                  => "Email enviado",
      :resend_confirmation_mail   => "Reenviar email de confirmação",

      # Posts
      :recent_posts       => "Mensagens recentes",
      :count_posts_found  => {:zero => "nenhuma mensagem", :one => "1 mensagem", :other => "{{count}} mensagens" },
      :topic              => "Discussão",
      :forum              => "Fórum",
      :post_updated       => "Mensagem modificada com sucesso",
      :post_created       => "Post criado com sucesso",
      :views_posts        => {
        :formatting_help        => "Formatação",
        :formatting_bold        => "*negrito*",
        :formatting_italics     => "_itálico_",
        :formatting_blockquote  => "bq. <span>citação</span>",
        :formatting_list        => "* ou # <span>(listas)</span>",
        :delete                 => "Apagar mensagem",
      },
      :admin              => {
        :edit_post                 => "Editar mensagem",
        :user_is_an_administrator  => "Administrador",
      },

      # User
      
      # Missing on User#show
      :all => "todas",
      :monitored => "monitoradas",
      :user_since => "cadastrado em {{date}}",
      
      :password_confirm      => "Confirmação de Senha",
      :openid_url            => "URL do OpenID (opcional)",
      :city_label            => "Cidade (opcional)",
      :sign_up               => "Cadastrar",
      :activation_required   => "Seu cadastro foi feito. Ative sua conta clicando no link enviado ao seu email.",
      :account_updated       => "Informações de conta atualizadas com sucesso.",
      :signup_complete       => "Conta ativada.",
      :user_suspended        => "O usuário está suspenso.",
      :user_unsuspended      => "O usuário não está mais suspenso.",
      :user_active           => "ativo",
      :user_pending          => "pendente",
      :count_users           => {:zero => "nenhum usuário", :one => "1 usuário", :other => "{{num}} usuários" },
      :count_users_active    => {:zero => "nenhum usuário ativo", :one => "1 usuário ativo", :other => "{{num}} usuários ativos" },
      :count_users_lurking   => {:zero => "nenhum usuário escondido", :one => "1 usuário escondido", :other => "{{num}} usuários escondidos" },
      :login_or_signup_and_comment     => "Faça o login",
      :user_is_administrator => "Administrador",
      :select_responsability => 'Selecione a responsabilidade',
      :select_state => 'Selecione o estado',
      :select_state_first => 'Selecione o estado primeiro',
      :select_company_size => 'Selecione a quantidade de funcionários',
      :working_since => 'Ano que começou a trabalhar',
      :update                    => "Alterar",
      :views_users           => {
        :reset_password            => "Esqueci minha senha",
        :email_directions          => "Informe seu endereço de email:",
        :send_email                => "Enviar link por email",
        :basics_title              => "Informações Principais",
        :email_title               => "Email",
        :password_title            => "Senha",
        :password_field            => "Digite a nova senha duas vezes. Deixe em branco para não alterar.",
        :once                      => "senha",
        :and_again                 => "confirmação",
        :change_email_or_password  => "Salvar email e/ou senha",
        :profile                   => "Perfil do Usuário",
        :display_name              => "Nome",
        :display_name_or_login     => "Nome / Login",
        :openid_url_title          => "OpenID",
        :open_id_field             => "URL da Identidade OpenID",
        :website_title             => "Endereço Web",
        :without_http              => "sem http://",
        :bio_title                 => "Sobre mim",
        :update_profile            => "Salvar perfil",
        :avatars_title             => "Avatar",
        :gravatar_notice           => "Para ter seu avatar exibido neste fórum, registre-se no {{gravatar}}.",

        :find_a_user               => "Busca de Usuários",
        :search_title              => "Procurar",
        :posts_title               => "Mensagens",
        :current_status_title      => "Status",
      },
      
      # show_all control
      :show_all =>       "Mostrar todos os tópicos",
      :hide_downvoted => "Mostrar somente com pontuação positiva",
    }
  }
}
