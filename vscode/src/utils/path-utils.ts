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
