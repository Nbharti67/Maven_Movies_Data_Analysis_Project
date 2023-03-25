/* We will be hosting a meeting with all of our staff and advisors soon. 
Could you pull one list of all staff and advisor names and include a column noting whether they are staff member or advisor? Thanks
*/

use mavenmovies;

select 
	'staff' as type,
    first_name,
    last_name
from staff
union
select 
	'advisor' as type,
    first_name,
    last_name
from advisor
;

