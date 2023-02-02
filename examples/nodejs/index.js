const { execSync } = require("child_process");

exports.handler = async event => {
  execSync("ldd /opt/bin/wkhtmltopdf", { encoding: "utf8", stdio: "inherit" });

  execSync("wkhtmltopdf -V", { encoding: "utf8", stdio: "inherit" });
};
