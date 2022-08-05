unit udr_log;

interface

{$IFDEF UDRLOG}

uses
  Data.DB,

  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.UI.Intf,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.Stan.Param,
  FireDAC.DatS,
  FireDAC.DApt.Intf,
  FireDAC.DApt,
  FireDAC.ConsoleUI.Wait,
  FireDAC.Phys.FBDef,
  FireDAC.Phys.IBBase,
  FireDAC.Phys.FB,
  FireDAC.Comp.UI,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TUdrLog = class
  private
    class var FDefault     : TUdrLog;
    class var FFBDriverLink: TFDPhysFBDriverLink;
    class var FWaitCursor  : TFDGUIxWaitCursor;
  private
    FConnection      : TFDConnection;
    FTransactionWrite: TFDTransaction;
    FLog             : TFDQuery;
  public
    procedure Action(aObject: TObject; aIsDestroy: Boolean);
  public
    constructor Create;
    destructor Destroy; override;
  public
    class constructor Create;
    class destructor Destroy;
    class property default: TUdrLog read FDefault;
  end;
{$ENDIF UDRLOG}

implementation

{$IFDEF UDRLOG}

procedure TUdrLog.Action(aObject: TObject; aIsDestroy: Boolean);
begin
  if FConnection.Connected then
  begin
    FTransactionWrite.StartTransaction;
    try
      if not FLog.Prepared then
        FLog.Prepare;
      FLog.ParamByName('path').AsString := aObject.QualifiedClassName;
      FLog.ParamByName('handle').AsLargeInt := NativeUInt(aObject);
      FLog.ParamByName('is_delete').AsSmallInt := Smallint(aIsDestroy);
      FLog.ExecSQL;
      FTransactionWrite.Commit;
    except
      FTransactionWrite.Rollback
    end;
  end;
end;

class constructor TUdrLog.Create;
begin
  FDefault := TUdrLog.Create;

  FFBDriverLink := TFDPhysFBDriverLink.Create(nil);
  FFBDriverLink.VendorLib := 'fbclient.dll';
end;

class destructor TUdrLog.Destroy;
begin
  FDefault.Destroy;
  FFBDriverLink.Destroy;
end;

constructor TUdrLog.Create;
begin
  inherited Create;

  FConnection := TFDConnection.Create(nil);

  FTransactionWrite := TFDTransaction.Create(FConnection);
  FTransactionWrite.Connection := FConnection;
  FTransactionWrite.Options.AutoStart := False;
  FTransactionWrite.Options.AutoCommit := False;

  FConnection.Transaction := FTransactionWrite;
  FConnection.UpdateTransaction := FTransactionWrite;

  with FConnection.Params do
  begin
    //Values['Database'] := 'z:\__data\fb\Bulak-RF.fdb';
    Values['Database'] := 'Z:\database\Firebird\mbulak.fdb';
    Values['User_Name'] := 'SYSDBA';
    Values['Password'] := 'masterkey';
    Values['CharacterSet'] := 'UTF8';
    Values['DriverID'] := 'FB';
  end;

  FLog := TFDQuery.Create(FConnection);
  FLog.Connection := FConnection;
  FLog.Transaction := FTransactionWrite;
  FLog.SQL.Text := 'update or insert into udr_log (path, handle, is_delete) values (:path, :handle, :is_delete) matching (handle)';

  try
    FConnection.Connected := True;
    // FLog.Prepare;
  except
  end;
end;

destructor TUdrLog.Destroy;
begin
  FConnection.Destroy;
  FWaitCursor.Destroy;
  inherited;
end;

initialization
  FDManager.SilentMode := True;

{$ENDIF UDRLOG}

end.
