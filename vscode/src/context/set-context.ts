import * as vscode from 'vscode';

export const setContexts = () => {
  // 判断当前是否为 Dart/Flutter 项目
  vscode.commands.executeCommand('setContext', 'isDartProject', "workspaceContains:**/pubspec.yaml");
};