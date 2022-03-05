unit library_external;

interface

uses
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF MSWINDOWS}
  firebird_classes;

implementation

{$IFDEF MSWINDOWS}

procedure DLLMain(AReason: DWORD);
begin
  case AReason of
    // DLL_PROCESS_ATTACH:
    // DLL_THREAD_ATTACH:
    DLL_THREAD_DETACH:
      RLibraryHeapManager.ClearDependentFromParent(nil);
    // DLL_PROCESS_DETACH:
  end
end;
{$ENDIF MSWINDOWS}

initialization

{$IFDEF MSWINDOWS}
  DLLProc := @DLLMain;
// DLLMain(DLL_PROCESS_ATTACH);
{$ENDIF MSWINDOWS}

end.
