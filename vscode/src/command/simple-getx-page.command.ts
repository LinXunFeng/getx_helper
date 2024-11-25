import * as vscode from 'vscode';

import { compile } from '../utils/ejs-utils';
import { generateCode } from '../utils/file-utils';
import { showInputBox } from '../utils/vscode-utils';
import { underline2Hump } from '../utils/string-utils';
import { fetchCurrentPathForImport } from '../utils/path-utils';

import headerTemplatePosition from '../template/simple-getx-page/header/header.dart.ejs';
import pageTemplatePosition from '../template/simple-getx-page/page/page.dart.ejs';
import logicTemplatePosition from '../template/simple-getx-page/logic/logic.dart.ejs';
import stateTemplatePosition from '../template/simple-getx-page/state/state.dart.ejs';

export const newSimpleGetxPage = async (uri: vscode.Uri) => {
  const name: string = await showInputBox() || '';
  if (!name) { return; }
  const nameLargeHump = underline2Hump(name, true);
  const importPath = fetchCurrentPathForImport(uri.path, name);

  // header
  const headerContent = await compile(headerTemplatePosition, {
    name,
    nameLargeHump,
    importPath,
  });
  generateCode(
    vscode.Uri.joinPath(uri, name, 'header').path,
    `${name}_header.dart`,
    headerContent
  );

  // page
  const pageContent = await compile(pageTemplatePosition, {
    name,
    nameLargeHump,
    importPath,
  });
  generateCode(
    vscode.Uri.joinPath(uri, name, 'page').path,
    `${name}_page.dart`,
    pageContent
  );

  // logic
  const logicContent = await compile(logicTemplatePosition, {
    name,
    nameLargeHump,
    importPath,
  });
  generateCode(
    vscode.Uri.joinPath(uri, name, 'logic').path,
    `${name}_logic.dart`,
    logicContent
  );

  // state
  const stateContent = await compile(stateTemplatePosition, {
    nameLargeHump,
  });
  generateCode(
    vscode.Uri.joinPath(uri, name, 'state').path,
    `${name}_state.dart`,
    stateContent
  );
};