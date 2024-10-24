const ACCESS_KEY = "";
const SECRET_KEY = "";
const BUCKET = "qiita-hackathon-gaudi";
const REGION = "ap-northeast-1";
const EXCLUDE_SHEETS = ["Genre"]; // ここに対象外にしたいシート名を追加

function uploadAllSheetsToS3() {
  const ss = SpreadsheetApp.getActiveSpreadsheet(); // スプレッドシートを取得
  var sheets = ss.getSheets(); // 全てのシートを取得

  sheets.forEach((sheet) => {
    var sheetName = sheet.getName();

    // シート名が除外リストに含まれている場合、スキップ
    if (EXCLUDE_SHEETS.includes(sheetName)) {
      return;
    }

    var data = sheet.getDataRange().getValues();
    var bgColors = sheet.getDataRange().getBackgrounds();
    var csv = "";

    // データをチェックしながらループ
    for (var i = 0; i < data.length; i++) {
      var row = [];

      for (var j = 0; j < data[i].length; j++) {
        // 背景色が赤 (#ff0000) のセルをスキップ
        if (bgColors[i][j] === "#ff0000") {
          continue;
        }
        row.push(`"${data[i][j]}"`);
      }

      csv += row.join(",") + "\n";
    }

    // バイナリに変換
    csv = Utilities.newBlob(csv, "text/csv", `${sheetName}.csv`);

    // S3ライブラリを用いてアップロード
    var s3 = S3.getInstance(ACCESS_KEY, SECRET_KEY);
    s3.putObject(BUCKET, `${sheetName}.csv`, csv, { logRequests: true });
  });
}
