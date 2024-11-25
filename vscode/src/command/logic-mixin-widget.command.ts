import * as vscode from 'vscode';

import { compile } from '../utils/ejs-utils';
import { generateCode } from '../utils/file-utils';
import { showInputBox } from '../utils/vscode-utils';
import { underline2Hump } from '../utils/string-utils';
import { fetchCurrentPathForImport } from '../utils/path-utils';

import widgetTemplatePosition from '../template/logic-mixin-widget/logic-mixin-widget.dart.ejs';

export const newLogicMixinWidget = async (uri: vscode.Uri) => {
  const name: string = await showInputBox(
    '',
    '请填写Widget名称（下划线式命名，如：my_widget）'
  ) || '';
  if (!name) { return; }
  const nameLargeHump = underline2Hump(name, true);

  let popCount = 0;
  const dirs = uri.path.split('/');
  let dirname = dirs.pop();
  if (dirname === 'widget' || dirname === 'widgets') {
    popCount++;
    dirname = dirs.pop();
  }
  
  let importUri = uri;
  for (let index = 0; index < popCount; index++) {
    importUri = vscode.Uri.joinPath(importUri, '..');
  }
  const importPath = fetchCurrentPathForImport(importUri.path, '');
  const logicNameLargeHump = underline2Hump(`${dirname}_logic`, true);

  // widget
  const widgetContent = await compile(widgetTemplatePosition, {
    name,
    dirname,
    nameLargeHump,
    importPath,
    logicNameLargeHump,
  });
  generateCode(
    uri.path,
    `${name}.dart`,
    widgetContent
  );
};