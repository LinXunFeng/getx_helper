import * as vscode from "vscode";

import { compile } from "../utils/ejs-utils";
import { generateCode } from "../utils/file-utils";
import { showInputBox } from "../utils/vscode-utils";
import { underline2Hump } from "../utils/string-utils";
import {
  fetchCurrentPathForImport,
  findPageRootByHeaderPresence,
} from "../utils/path-utils";

import widgetTemplatePosition from "../template/logic-mixin-widget/logic-mixin-widget.dart.ejs";

export const newLogicMixinWidget = async (uri: vscode.Uri) => {
  const name: string =
    (await showInputBox(
      "",
      "请填写Widget名称（下划线式命名，如：my_widget）"
    )) || "";
  if (!name) {
    return;
  }
  const nameLargeHump = underline2Hump(name, true);

  // 获取页面根目录的 URI
  const pageRootUri = await findPageRootByHeaderPresence(uri);
  // 获取页面根目录的名称作为 dirname
  const dirs = pageRootUri.path.split("/");
  const dirname = dirs[dirs.length - 1];

  const importPath = fetchCurrentPathForImport(pageRootUri.path, "");
  const logicNameLargeHump = underline2Hump(`${dirname}_logic`, true);

  // widget
  const widgetContent = await compile(widgetTemplatePosition, {
    name,
    dirname,
    nameLargeHump,
    importPath,
    logicNameLargeHump,
  });
  generateCode(uri.path, `${name}.dart`, widgetContent);
};
