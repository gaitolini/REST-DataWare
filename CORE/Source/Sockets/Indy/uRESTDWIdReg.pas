unit uRESTDWIdReg;

{$I ..\..\Source\Includes\uRESTDWPlataform.inc}

{
  REST Dataware vers�o CORE.
  Criado por XyberX (Gilbero Rocha da Silva), o REST Dataware tem como objetivo o uso de REST/JSON
 de maneira simples, em qualquer Compilador Pascal (Delphi, Lazarus e outros...).
  O REST Dataware tamb�m tem por objetivo levar componentes compat�veis entre o Delphi e outros Compiladores
 Pascal e com compatibilidade entre sistemas operacionais.
  Desenvolvido para ser usado de Maneira RAD, o REST Dataware tem como objetivo principal voc� usu�rio que precisa
 de produtividade e flexibilidade para produ��o de Servi�os REST/JSON, simplificando o processo para voc� programador.

 Membros do Grupo :

 XyberX (Gilberto Rocha)    - Admin - Criador e Administrador do CORE do pacote.
 Alexandre Abbade           - Admin - Administrador do desenvolvimento de DEMOS, coordenador do Grupo.
 Anderson Fiori             - Admin - Gerencia de Organiza��o dos Projetos
 Fl�vio Motta               - Member Tester and DEMO Developer.
 Mobius One                 - Devel, Tester and Admin.
 Gustavo                    - Criptografia and Devel.
 Eloy                       - Devel.
 Roniery                    - Devel.
}

interface

uses
  {$IFDEF FPC}
    StdCtrls, ComCtrls, Forms, ExtCtrls, DBCtrls, DBGrids, Dialogs, Controls, Variants, TypInfo, uRESTDWIdBase,
    LResources, LazFileUtils, SysUtils, FormEditingIntf, PropEdits, lazideintf, ProjectIntf, ComponentEditors, Classes, fpWeb, uRESTDWAbout;
  {$ELSE}
   Windows, SysUtils, Variants, StrEdit, TypInfo, uRESTDWIdBase, uRESTDWAbout,
   RTLConsts,
   {$IFDEF COMPILER16_UP}
   UITypes,
   {$ENDIF}
   {$if CompilerVersion > 22}
    ToolsApi, vcl.Graphics, DesignWindows, DesignEditors, DBReg, DSDesign,
    DesignIntf, ExptIntf, Classes, Db, ColnEdit;
   {$ELSE}
    ToolsApi, Graphics, DesignWindows, DesignEditors, DBReg, DesignIntf,
    Classes, Db, DbTables, DSDesign, ColnEdit;
   {$IFEND}
  {$ENDIF}

Type
 TPoolersList = Class(TStringProperty)
 Public
  Function  GetAttributes  : TPropertyAttributes; Override;
  Procedure GetValues(Proc : TGetStrProc);        Override;
  Procedure Edit;                                 Override;
End;

Type
 TRESTDWAboutDialogProperty = class({$IFDEF FPC}TClassPropertyEditor{$ELSE}TPropertyEditor{$ENDIF})
Public
 Procedure Edit; override;
 Function  GetAttributes : TPropertyAttributes; Override;
 Function  GetValue      : String;              Override;
End;

Procedure Register;

Implementation

uses uRESTDWConsts, uRESTDWCharset{$IFDEF FPC}, utemplateproglaz{$ENDIF};

Function TPoolersList.GetAttributes : TPropertyAttributes;
Begin
  // editor, sorted list, multiple selection
 Result := [paValueList, paSortList];
End;

Procedure TPoolersList.Edit;
Var
 vTempData : String;
Begin
 Inherited Edit;
 Try
  vTempData := GetValue;
  SetValue(vTempData);
 Finally
 End;
end;

Procedure TPoolersList.GetValues(Proc : TGetStrProc);
Var
 vLista : TStringList;
 I      : Integer;
Begin
 //Provide a list of Poolers
 With GetComponent(0) as TRESTDWIdDatabase Do
  Begin
   Try
    vLista := TRESTDWIdDatabase(GetComponent(0)).PoolerList;
    For I := 0 To vLista.Count -1 Do
     Proc (vLista[I]);
   Except
   End;
  End;
End;

Procedure Register;
Begin
 RegisterComponents('REST Dataware - Service',     [TRESTDWIdServicePooler,
                                                    TRESTDWIdServiceCGI]);

 RegisterComponents('REST Dataware - Client''s',   [TRESTDWIdClientREST,
                                                    TRESTDWIdClientPooler]);
//                                                    TRESTDWIdClientNotification]);

 RegisterComponents('REST Dataware - CORE - DB',   [TRESTDWIdDataBase]);
 RegisterPropertyEditor(TypeInfo(String),           TRESTDWIdDatabase,     'PoolerName',      TPoolersList);
// RegisterPropertyEditor(TypeInfo(String),       TRESTDWConnectionServer,   'PoolerName',      TPoolersListCDF);
// RegisterPropertyEditor(TypeInfo(String),       TRESTDWConnectionParams,   'PoolerName',      TPoolersListCDF);
 {$IFNDEF FPC}
  RegisterPropertyEditor(TypeInfo(TRESTDWAboutInfo),   Nil, 'AboutInfo', TRESTDWAboutDialogProperty);
 {$ELSE}
  RegisterPropertyEditor(TypeInfo(TRESTDWAboutInfo),   Nil, 'AboutInfo', TRESTDWAboutDialogProperty);
 {$ENDIF}
End;

{$IFDEF FPC}
 Procedure UnlistPublishedProperty (ComponentClass:TPersistentClass; const PropertyName:String);
 var
   pi :PPropInfo;
 begin
   pi := TypInfo.GetPropInfo (ComponentClass, PropertyName);
   if (pi <> nil) then
     RegisterPropertyEditor (pi^.PropType, ComponentClass, PropertyName, PropEdits.THiddenPropertyEditor);
 end;
{$ENDIF}

Procedure TRESTDWAboutDialogProperty.Edit;
Begin
 RESTDWAboutDialog;
End;

Function TRESTDWAboutDialogProperty.GetAttributes: TPropertyAttributes;
Begin
 Result := [paDialog, paReadOnly];
End;

Function TRESTDWAboutDialogProperty.GetValue: String;
Begin
 Result := 'Version : '+ RESTDWVERSAO;
End;

initialization

Finalization

end.