{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.commento;
in {
  options = {
    services.commento = {
      
      enable = mkEnableOption "Commento";

      user = mkOption {
        type = types.str;
        default = "commento";
        description = "User account under which Commento runs.";
      };

      package = mkOption {
        type = types.package;
        example = literalExample "pkgs.commento";
        default = pkgs.commento;
        description = "Commento package to use.";
      };
      
      origin = mkOption {
        type = types.str;
        default = null;
        example = "http://commento.example.com";
        description = ''
          This should be set to the subdomain or the IP address hosting Commento. All API requests will go to this server.
          This may include subdirectories if Commento is hosted behind a reverse proxy, for example.
          Include the protocol in the value to use HTTP/HTTPS.
        '';
      };

      postgresUri = mkOption {
        type = types.str;
        default = null;
        example = "postgres://user:pass@ip:5432/commento?sslmode=disable";
        description = ''
          A PostgreSQL server URI, including the database name.
        '';
      };

      configFile = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "/etc/commento.env";
        description = ''
          A configuration file for Commento.
          Useful to store secrets and credentials. 
          No config file will be loaded by default, if left unspecified.
          See https://docs.commento.io/configuration/backend/#configuration-file for more details.
        '';
      };

      bindAddress = mkOption {
        type = types.nullOr types.str;
        default = origin;
        example = "172.0.0.17";
        description = ''
          The address to bind the Commento server to.
          Useful if the server has multiple network interfaces. 
          If not specified, this value defaults to origin.
        '';
      };

      port = mkOption {
        type = types.nullOr types.int;
        default = 8080;
        example = 3000;
        description = ''
          The port to bind the Commento server to.
        '';
      };

      cdnPrefix = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "http://d111111abcdef8.cloudfront.net";
        description = ''
          Useful if you'd like to use a CDN with Commento (like AWS Cloudfront, for example) for faster delivery of static assets.
          You must set the CDN's origin value as origin.
          If not specified, a CDN is not used.
        '';
      };

      forbidNewOwners = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Used to disable new dashboard registrations.
          Useful if you are the only person using Commento on your server.
          Does not impact the creation of accounts for your readers.
        '';
      };

      gzipStatic = mkOption {
        type = types.bool;
        default = false;
        description = ''
          If set to true, all static content will be served GZipped if the client's browser supports compression.
        '';
      };

      smtpHost = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "smtp.gmail.com";
        description = ''
          SMTP host the server should use to send emails.
        '';
      };

      smtpPort = mkOption {
        type = types.nullOr types.int;
        default = null;
        example = "587";
        description = ''
          SMTP port the server should use to send emails.
        '';
      };
      
      smtpUsername = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "example@gmail.com";
        description = ''
          SMTP username the server should use to send emails.
        '';
      };      

      smtpPassword = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "hunter2";
        description = ''
          SMTP password the server should use to send emails.
        '';
      };

      smtpFromAddress = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "no-reply@example.com";
        description = ''
          SMTP sender address the server should use to send emails.
        '';
      };

      akismetKey = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "836d01853fd6";
        description = ''
          Akismet API key. Create a key in your Akismet dashboard.
          Akismet integration is turned off when this value is left empty.
        '';
      };

      googleKey = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "961031300431-0fe76kc72xvo0otts78ug2aqmi4is067.apps.googleusercon";
        description = ''
          Google OAuth key. Create a new project in the Google developer console to generate a set of credentials.
          Google login is turned off when this value is left empty
        '';
      };

      googleSecret = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "XmaKz7gRkWw3MQgoAHmApuwb";
        description = ''
          Google OAuth secret. Create a new project in the Google developer console to generate a set of credentials.
          Google login is turned off when this value is left empty
        '';
      };

      githubKey = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "uk3juvzyyejgxhbym1sqkn3t";
        description = ''
          GitHub OAuth key.
          Create a new OAuth app in GitHub developer settings to generate a set of credentials. 
          GitHub login is turned off when this value is left empty.
        '';
      };

      githubSecret = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "2fbdc6bdbb7c02119fd8fa70b7bdcfa7af8e2c";
        description = ''
          GitHub OAuth secret.
          Create a new OAuth app in GitHub developer settings to generate a set of credentials. 
          GitHub login is turned off when this value is left empty.
        '';
      };
      
      gitlabKey = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "78433742e6bad8fdf11261716daf6d1729c805d534a09707342d986cd52093d4";
        description = ''
          Gitlab OAuth key.
          Create a new application in your GitLab settings to generate a set of credentials.
          GitLab login is turned off when this value is left empty.
        '';
      };

      gitlabSecret = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "cf73049b59f63915bbdc318b1e2e8ecbbf5b8bafb18f1dd84d68adf8951b762b";
        description = ''
          Gitlab OAuth secret.
          Create a new application in your GitLab settings to generate a set of credentials.
          GitLab login is turned off when this value is left empty.
        '';
      };
      
      twitterKey = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "HsWM4q8lcKNiv6idWvRdeSjS";
        description = ''
          Twitter OAuth key.
          Create an app in the Twitter developer dashboard to generate a set of credentials.
          Twitter login is turned off when this value is left empty.
        '';
      };

      twitterSecret = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "9j60WfN3LG6GAMbU5LCch1HQ6tT4ytiOzO95rM3DVD5dXHFT";
        description = ''
          Twitter OAuth secret.
          Create an app in the Twitter developer dashboard to generate a set of credentials.
          Twitter login is turned off when this value is left empty.
        '';
      };      
    };
  };

  config = mkIf cfg.enable {

    users.users.mailhog = {
      name = cfg.user;
      description = "Commento service user";
      isSystemUser = true;
    };
    
    systemd.services.commento = {

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      description = "Start the Commento server.";

      environment = {
        COMMENTO_ORIGIN = cfg.origin;
        COMMENTO_POSTGRES = cfg.postgresUri;
        COMMENTO_CONFIG_FILE = cfg.configFile;
        COMMENTO_PORT = toString cfg.port;
        COMMENTO_CDN_PREFIX = cfg.cdnPrefix;
        COMMENTO_FORBID_NEW_OWNERS = if cfg.forbidNewOwners then "true" else "false";
        COMMENTO_GZIP_STATIC = if cfg.gzipStatic then "true" else "false";
        COMMENTO_SMTP_HOST = cfg.smtpHost;
        COMMENTO_SMTP_PORT = cfg.smtpPort;
        COMMENTO_SMTP_USERNAME = cfg.smtpUsername;
        COMMENTO_SMTP_PASSWORD = cfg.smtpPassword;
        COMMENTO_SMTP_FROM_ADDRESS = cfg.smtpFromAddress;
        COMMENTO_AKISMET_KEY = cfg.akismetKey;
        COMMENTO_GOOGLE_KEY = cfg.googleKey;
        COMMENTO_GOOGLE_SECRET = cfg.googleSecret;
        COMMENTO_GITHUB_KEY = cfg.githubKey;
        COMMENTO_GITHUB_SECRET = cfg.githubSecret;
        COMMENTO_GITLAB_KEY = cfg.gitlabKey;
        COMMENTO_GITLAB_SECRET = cfg.gitlabSecret;
        COMMENTO_TWITTER_KEY = cfg.twitterKey;
        COMMENTO_TWITTER_SECRET = cfg.twitterSecret;
      };
      
      serviceConfig = {
         Type = "simple";
         User = cfg.user;
         ExecStart = ''${cfg.package}/commento'';         
      };
      
    };
  };
}
