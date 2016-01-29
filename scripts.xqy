(: Configure full backup every 10 minutes for "Documents" database :)
xquery version "1.0-ml";
import module namespace admin = "http://marklogic.com/xdmp/admin"
  at "/MarkLogic/admin.xqy";

let $config := admin:get-configuration()
let $database := xdmp:database("Documents")
let $backup := admin:database-minutely-backup(
  "/backups", (: Location to save to :)
  10,         (: Minutes between each backup :)
  20,         (: Max backups to keep :)
  false(),    (: Include security db :)
  false(),    (: Include schemas db :)
  false()     (: Include triggers db :)
)
let $spec := admin:database-add-backup($config, $database, $backup)
return
  admin:save-configuration($spec)

(: Configure incremental backup every 2 minutes for "Documents" database :)
xquery version "1.0-ml";
import module namespace admin = "http://marklogic.com/xdmp/admin"
  at "/MarkLogic/admin.xqy";

let $config := admin:get-configuration()
let $database := xdmp:database("Documents")
let $backup := admin:database-minutely-incremental-backup(
  "/backups", (: Location to save to :)
  2,          (: Minutes between each incremental backup :)
  false(),    (: Include security db :)
  false(),    (: Include schemas db :)
  false()     (: Include triggers db :)
)
let $spec := admin:database-add-backup($config, $database, $backup)
return
  admin:save-configuration($spec)

(: Get current backups for "Documents" database :)
xquery version "1.0-ml";
import module namespace admin = "http://marklogic.com/xdmp/admin"
  at "/MarkLogic/admin.xqy";

let $config := admin:get-configuration()
return
  admin:database-get-backups($config, xdmp:database("Documents") )

(: Get whether "Documents" database backups are enabled :)
xquery version "1.0-ml";
import module namespace admin = "http://marklogic.com/xdmp/admin"
  at "/MarkLogic/admin.xqy";
declare namespace db =  "http://marklogic.com/xdmp/database";

let $backup-ids := admin:database-get-backups(
  admin:get-configuration(),
  xdmp:database("Documents")
)//db:backup-id/fn:data()
return
  admin:database-backup-get-enabled(
    admin:get-configuration(),
    xdmp:database("Documents"),
    $backup-ids
  )

(: Restore "Documents" forest at specific dateTime :)
xquery version "1.0-ml";

let $forest-ids := xdmp:database-forests(xdmp:database("Documents"))
let $date := dateTime(xs:date('2016-01-28'),xs:time('14:53:02'))
return
  xdmp:database-restore($forest-ids,"/backups", $date);

(: Delete current backups for "Documents" database :)
xquery version "1.0-ml";
import module namespace admin = "http://marklogic.com/xdmp/admin"
  at "/MarkLogic/admin.xqy";
declare namespace db="http://marklogic.com/xdmp/database";

let $backup-ids := admin:database-get-backups(
  admin:get-configuration(),
  xdmp:database("Documents")
)//db:backup-id/fn:data()
let $spec := admin:database-delete-backup-by-id(
  admin:get-configuration(),
  xdmp:database("Documents"),
  $backup-ids
)
return
  admin:save-configuration($spec)
