import { existsSync, writeFile, readdir, readdirSync } from 'fs';
import * as mkdirp from "mkdirp";
import path = require('path');
import { handlePath } from './path-utils';

/// 查找pubspec.yaml文件
export const findPubspecYaml = (path: string) => {
  return upwardSearchFile(path, 'pubspec.yaml');
};

/// 向上查找文件，返回文件路径
export const upwardSearchFile = (
  directoryPath: string, 
  filename: string
): string => {
  directoryPath = handlePath(directoryPath);
  if (directoryPath.length === 0) { return ''; }
  const files = readdirSync(directoryPath);
  if (files.includes(filename)) {
    return path.join(directoryPath, filename);
  }
  const upwardDirectoryPath = path.resolve(directoryPath, '..');
  return upwardSearchFile(upwardDirectoryPath, filename);
};

/// 创建目录
export const createDirectory = async (dir: string) => {
  dir = handlePath(dir);
  mkdirp.sync(dir);
};

/// 生成代码文件
export const generateCode = (
  targetDirectory: string,
  fileName: string,
  code: string
): Promise<void> => {
  targetDirectory = handlePath(targetDirectory);
  return new Promise<void>(async (resolve, reject) => {
    if (!existsSync(targetDirectory)) { // 目录不存在，先创建
      createDirectory(targetDirectory);
    }

    const filePath = path.join(targetDirectory, fileName);
    writeFile(filePath, code, 'utf-8', (error) => {
      if (error) {
        reject(error);
        return;
      }
      resolve();
    });
  });
};