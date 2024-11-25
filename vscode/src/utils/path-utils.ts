import * as path from 'path';
import * as yamlUtil from '../utils/yaml-utils';
import { findPubspecYaml } from '../utils/file-utils';

/// 获取用于import的当前路径
export const fetchCurrentPathForImport = (
  currentDirectoryPath: string,
  pageName: string
) => {
  const filePath = findPubspecYaml(currentDirectoryPath);
  if (filePath === '') { return; }
  const packageName = yamlUtil.parse(filePath).name;

  const currentPath = path.join(currentDirectoryPath, pageName);
  const libKeyStr = '/lib/';
  const libIndex = currentPath.indexOf(libKeyStr);
  const afterPath = currentPath.substring(libIndex + libKeyStr.length);
  const finalPath = path.join(packageName, afterPath);
  return finalPath;
};