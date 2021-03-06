<?php
/*+***********************************************************************************************************************************
 * The contents of this file are subject to the YetiForce Public License Version 1.1 (the "License"); you may not use this file except
 * in compliance with the License.
 * Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or implied.
 * See the License for the specific language governing rights and limitations under the License.
 * The Original Code is YetiForce.
 * The Initial Developer of the Original Code is YetiForce. Portions created by YetiForce are Copyright (C) www.yetiforce.com. 
 * All Rights Reserved.
 *************************************************************************************************************************************/
class OffersPending{
	public $name = 'Offers pending';
	public $sequence = 2;
	public $reference = 'Quotes';
	
    public function process( $instance ) {
		$log = vglobal('log');
		$log->debug("Entering OffersPending::process() method ...");
		$adb = PearDatabase::getInstance();
		$quotes ='SELECT COUNT(quoteid) as count FROM vtiger_quotes
				INNER JOIN vtiger_crmentity ON vtiger_crmentity.crmid=vtiger_quotes.quoteid
				AND vtiger_crmentity.deleted=0
				WHERE vtiger_quotes.potentialid = ? AND vtiger_quotes.quotestage NOT IN (?, ?)';
		$result = $adb->pquery($quotes, array($instance->getId(), 'Accepted', 'Rejected'));
		$count = $adb->query_result($result, 0, 'count');
		$log->debug("Exiting OffersPending::process() method ...");
		return $count;
    }
}