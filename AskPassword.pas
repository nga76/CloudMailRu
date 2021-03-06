unit AskPassword;

interface

uses
	Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, MRC_Helper;

type
	TAskPasswordForm = class(TForm)
		PasswordEditLabel: TLabel;
		PasswordEdit: TEdit;
		OkButton: TButton;
		UseTCPwdMngrCB: TCheckBox;
		class function AskPassword(ParentWindow: HWND; AccountName: WideString; var Password: WideString; var UseTCPwdMngr: Boolean; DisablePWDManagerCB: Boolean = false; HintLabelText: WideString = 'Enter account password:'): integer;
		procedure PasswordEditChange(Sender: TObject);
		procedure FormShow(Sender: TObject);
		procedure FormActivate(Sender: TObject);
	private
		{Private declarations}
		procedure WMHotKey(var Message: TMessage); message WM_HOTKEY;
	public
		{Public declarations}
	end;

implementation

{$R *.dfm}

{TAskPasswordForm}
class function TAskPasswordForm.AskPassword(ParentWindow: HWND; AccountName: WideString; var Password: WideString; var UseTCPwdMngr: Boolean; DisablePWDManagerCB: Boolean = false; HintLabelText: WideString = 'Enter account password:'): integer;
var
	AskPasswordForm: TAskPasswordForm;
begin
	try
		AskPasswordForm := TAskPasswordForm.Create(nil);
		AskPasswordForm.ParentWindow := ParentWindow;
		AskPasswordForm.PasswordEditLabel.Caption := HintLabelText;
		AskPasswordForm.Caption := AccountName + ' password';
		AskPasswordForm.UseTCPwdMngrCB.Enabled := not DisablePWDManagerCB;
		AskPasswordForm.UseTCPwdMngrCB.Checked := UseTCPwdMngr;
		RegisterHotKey(AskPasswordForm.Handle, 1, 0, VK_ESCAPE);
		RegisterHotKey(AskPasswordForm.Handle, 2, 0, VK_RETURN);

		result := AskPasswordForm.ShowModal;
		if result = mrOk then
		begin
			Password := AskPasswordForm.PasswordEdit.Text;
			UseTCPwdMngr := AskPasswordForm.UseTCPwdMngrCB.Checked;
		end;
	finally
		FreeAndNil(AskPasswordForm);
	end;
end;

procedure TAskPasswordForm.FormActivate(Sender: TObject);
begin
	CenterWindow(Self.ParentWindow, Self.Handle);
end;

procedure TAskPasswordForm.FormShow(Sender: TObject);
begin
	(Sender as TAskPasswordForm).PasswordEdit.SetFocus;
end;

procedure TAskPasswordForm.PasswordEditChange(Sender: TObject);
begin
	OkButton.Enabled := PasswordEdit.Text <> EmptyWideStr;
end;

procedure TAskPasswordForm.WMHotKey(var Message: TMessage);
begin
	if Message.LParamHi = VK_ESCAPE then
		Close;
	if (Message.LParamHi = VK_RETURN) and OkButton.Enabled then
		OkButton.Click;
end;

end.
