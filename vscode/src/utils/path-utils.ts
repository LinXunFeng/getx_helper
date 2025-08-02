import * as vscode from "vscode";
import * as path from "path";
import * as yamlUtil from "../utils/yaml-utils";
import { findPubspecYaml } from "../utils/file-utils";
import * as os from "os";

const platform = process.env.npm_config_platform || os.platform();

/// 获取用于import的当前路径
export const fetchCurrentPathForImport = (
  currentDirectoryPath: string,
  pageName: string
) => {
  currentDirectoryPath = handlePath(currentDirectoryPath);
  const filePath = findPubspecYaml(currentDirectoryPath);
  if (filePath === "") {
    return;
  }
  const packageName = yamlUtil.parse(filePath).name;

  // mac path: /home/Flutter/xxxx/lib/pages/home
  // windows path: d:\\Projects\\Flutter\\xxxx\\lib\\pages\\home
  const currentPath = path.join(currentDirectoryPath, pageName);
  const libKeyStr = platform === "win32" ? "\\lib\\" : "/lib/";
  const libIndex = currentPath.indexOf(libKeyStr);
  const afterPath = currentPath.substring(libIndex + libKeyStr.length);
  // path.join() 具有平台差异，在 windows 上拼接出来的路径，使用的分割符为 \\，但 dart 文件中导包需要使用的是 /，所以此处需要替换一下导包的路径分割符
  let finalPath = path.join(packageName, afterPath);
  if (platform === "win32") {
    finalPath = finalPath.replaceAll("\\", "/");
  }
  return finalPath;
};

/// 处理平台路径
/// windows path: /d:/Projects/Flutter/xxxx/lib/pages -> d:/Projects/Flutter/xxxx/lib/pages
export const handlePath = (path: string) => {
  if (platform === "win32" && path.startsWith("/")) {
    path = path.substring(1);
  }
  return path;
};

/**
 * 向上查找包含 'header' 子目录的最近父级目录的 URI。
 * 如果找不到，则返回原始 URI 的父级目录。
 * @param currentUri 当前文件的 URI
 * @returns 包含 'header' 子目录的父级目录的 URI，或原始 URI 的父级目录。
 */
export const findPageRootByHeaderPresence = async (
  currentUri: vscode.Uri
): Promise<vscode.Uri> => {
  let currentDirUri = currentUri;
  while (true) {
    const headerDirUri = vscode.Uri.joinPath(currentDirUri, "header");
    try {
      const stat = await vscode.workspace.fs.stat(headerDirUri);
      if (stat.type === vscode.FileType.Directory) {
        return currentDirUri; // 找到包含 header 目录的父目录
      }
    } catch (e) {
      // 目录不存在或无法访问，继续向上
    }

    const parentDirUri = vscode.Uri.joinPath(currentDirUri, "..");
    // 如果已经到达文件系统的根目录，并且没有找到 header 目录，则返回原始 URI 的父级目录
    if (parentDirUri.fsPath === currentDirUri.fsPath) {
      return vscode.Uri.joinPath(currentUri, "..");
    }
    currentDirUri = parentDirUri;
  }
};
