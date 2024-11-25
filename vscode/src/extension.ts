// The module 'vscode' contains the VS Code extensibility API
// Import the module and reference it with the alias vscode in your code below
import * as vscode from 'vscode';
import { setContexts } from './context/set-context';
import { newLogicMixinWidget } from './command/logic-mixin-widget.command';
import { newSimpleGetxPage } from './command/simple-getx-page.command';

// This method is called when your extension is activated
// Your extension is activated the very first time the command is executed
export function activate(context: vscode.ExtensionContext) {
	// 配置变量
	setContexts();

	// 配置命令
	context.subscriptions.push(
		vscode.commands.registerCommand(
			'getx-helper.logic-mixin-widget',
			newLogicMixinWidget,
		),
		vscode.commands.registerCommand(
			'getx-helper.simple-getx-page',
			newSimpleGetxPage,
		),
	);
}

// This method is called when your extension is deactivated
export function deactivate() {}
