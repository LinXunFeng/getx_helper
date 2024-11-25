import * as yaml from 'yaml';
import * as fs from 'fs';

/// 解析yaml文件
export const parse = (yamlPath: string): any => {
  return yaml.parse(fs.readFileSync(yamlPath, 'utf8'));
};