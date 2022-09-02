object DM: TDM
  OldCreateOrder = False
  Height = 329
  Width = 608
  object Connection: TFDConnection
    Params.Strings = (
      'User_Name=sysdba'
      'Password=masterkey'
      'Server=localhost'
      'Port=3050'
      'CharacterSet=utf8'
      'DriverID=FB')
    LoginPrompt = False
    Left = 40
    Top = 16
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    ScreenCursor = gcrAppWait
    Left = 40
    Top = 96
  end
  object sqlFuncionario: TFDQuery
    Connection = Connection
    SQL.Strings = (
      'select * from funcionario_movtc')
    Left = 160
    Top = 16
  end
end
