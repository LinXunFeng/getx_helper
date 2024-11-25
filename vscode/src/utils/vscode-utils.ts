import * as vscode from 'vscode';

export const showInputBox = async (
  prompt: string = '',
  placeHolder: string = '请填写页面名称（下划线式命名）',
): Promise<string | undefined> => {
  const options: vscode.InputBoxOptions = {
    prompt: prompt,
    placeHolder: placeHolder
  };
  return await vscode.window.showInputBox(options);
};