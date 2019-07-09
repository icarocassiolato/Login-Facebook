program LoginFacebook;

uses
  Vcl.Forms,
  uPrincipal in 'uPrincipal.pas' {FrmPrincipal},
  uLoginFacebookController in 'uLoginFacebookController.pas',
  uLoginFacebookView in 'uLoginFacebookView.pas' {FrmLoginFacebookView};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.CreateForm(TFrmLoginFacebookView, FrmLoginFacebookView);
  Application.Run;
end.
