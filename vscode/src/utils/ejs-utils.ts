import * as ejs from 'ejs';
import * as path from 'path';

export const compile = (templatePosition: any, data: ejs.Data) => {
  const templatePath = path.resolve(__dirname, templatePosition);

  return new Promise<string>((resolve, reject) => {
    ejs.renderFile(templatePath, { data }, {}, (err, result) => {
      if (err) {
        // console.log(err);
        reject(err);
        return;
      }
      resolve(result);
    });
  });
};