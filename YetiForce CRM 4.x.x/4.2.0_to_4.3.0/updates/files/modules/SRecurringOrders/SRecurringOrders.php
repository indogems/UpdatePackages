<?php
/**
 * @package YetiForce.CRMEntity
 * @copyright YetiForce Sp. z o.o.
 * @license YetiForce Public License 3.0 (licenses/LicenseEN.txt or yetiforce.com)
 * @author Radosław Skrzypczak <r.skrzypczak@yetiforce.com>
 */
include_once 'modules/Vtiger/CRMEntity.php';

class SRecurringOrders extends Vtiger_CRMEntity
{

	public $table_name = 'u_yf_srecurringorders';
	public $table_index = 'srecurringordersid';

	/**
	 * Mandatory table for supporting custom fields.
	 */
	public $customFieldTable = ['u_yf_srecurringorderscf', 'srecurringordersid'];

	/**
	 * Mandatory for Saving, Include tables related to this module.
	 */
	public $tab_name = ['vtiger_crmentity', 'u_yf_srecurringorders', 'u_yf_srecurringorderscf', 'u_yf_recurring_info', 'u_yf_srecurringorders_address', 'vtiger_entity_stats'];
	public $related_tables = ['u_yf_recurring_info' => ['srecurringordersid', 'u_yf_srecurringorders', 'srecurringordersid']];

	/**
	 * Mandatory for Saving, Include tablename and tablekey columnname here.
	 */
	public $tab_name_index = [
		'vtiger_crmentity' => 'crmid',
		'u_yf_srecurringorders' => 'srecurringordersid',
		'u_yf_srecurringorderscf' => 'srecurringordersid',
		'u_yf_recurring_info' => 'srecurringordersid',
		'u_yf_srecurringorders_address' => 'srecurringordersaddressid',
		'vtiger_entity_stats' => 'crmid'];

	/**
	 * Mandatory for Listing (Related listview)
	 */
	public $list_fields = [
		/* Format: Field Label => Array(tablename, columnname) */
		// tablename should not have prefix 'vtiger_'
		'LBL_SUBJECT' => ['srecurringorders', 'subject'],
		'Assigned To' => ['crmentity', 'smownerid']
	];
	public $list_fields_name = [
		/* Format: Field Label => fieldname */
		'LBL_SUBJECT' => 'subject',
		'Assigned To' => 'assigned_user_id',
	];

	/**
	 * @var string[] List of fields in the RelationListView
	 */
	public $relationFields = ['subject', 'assigned_user_id'];
	// Make the field link to detail view
	public $list_link_field = 'subject';
	// For Popup listview and UI type support
	public $search_fields = [
		/* Format: Field Label => Array(tablename, columnname) */
		// tablename should not have prefix 'vtiger_'
		'LBL_SUBJECT' => ['srecurringorders', 'subject'],
		'Assigned To' => ['vtiger_crmentity', 'assigned_user_id'],
	];
	public $search_fields_name = [
		/* Format: Field Label => fieldname */
		'LBL_SUBJECT' => 'subject',
		'Assigned To' => 'assigned_user_id',
	];
	// For Popup window record selection
	public $popup_fields = ['subject'];
	// For Alphabetical search
	public $def_basicsearch_col = 'subject';
	// Column value to use on detail view record text display
	public $def_detailview_recname = 'subject';
	// Used when enabling/disabling the mandatory fields for the module.
	// Refers to vtiger_field.fieldname values.
	public $mandatory_fields = ['subject', 'assigned_user_id'];
	public $default_order_by = '';
	public $default_sort_order = 'ASC';

	/**
	 * Invoked when special actions are performed on the module.
	 * @param String Module name
	 * @param String Event Type
	 */
	public function moduleHandler($moduleName, $eventType)
	{
		$adb = PearDatabase::getInstance();
		if ($eventType === 'module.postinstall') {
			$moduleInstance = CRMEntity::getInstance('SRecurringOrders');
			\App\Fields\RecordNumber::setNumber($moduleName, 'S-RO', '1');
			$adb->pquery('UPDATE vtiger_tab SET customized=0 WHERE name=?', ['SRecurringOrders']);

			$modcommentsModuleInstance = vtlib\Module::getInstance('ModComments');
			if ($modcommentsModuleInstance && file_exists('modules/ModComments/ModComments.php')) {
				include_once 'modules/ModComments/ModComments.php';
				if (class_exists('ModComments'))
					ModComments::addWidgetTo(['SRecurringOrders']);
			}
			CRMEntity::getInstance('ModTracker')->enableTrackingForModule(\App\Module::getModuleId($moduleName));
		}
	}

	public function getJoinClause($tableName)
	{
		if ($tableName == 'vtiger_recurring_info') {
			return 'LEFT JOIN';
		}
		return parent::getJoinClause($tableName);
	}
}
