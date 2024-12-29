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

  const currentPath = path.join(currentDirectoryPath, pageName);
  const libKeyStr = "/lib/";
  const libIndex = currentPath.indexOf(libKeyStr);
  const afterPath = currentPath.substring(libIndex + libKeyStr.length);
  const finalPath = path.join(packageName, afterPath);
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
