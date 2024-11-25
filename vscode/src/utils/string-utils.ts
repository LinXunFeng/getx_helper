/// 下划线转驼峰（eg: hello_world -> helloWorld）
export const underline2Hump = (
  s: string, 
  isLarge: boolean = false
) => {
  let str: string = s.replace(/_(\w)/g, (_, letter) => {
    return letter.toUpperCase();
  });
  if (isLarge) {
    str = str.slice(0, 1).toUpperCase() + str.slice(1);
  }
  return str;
};

/// 驼峰转下划线（eg: helloWorld -> hello_world）
export const hump2underline = (s: string) => {
  return s.replace(/([A-Z])/g, '_$1').toLowerCase();
};