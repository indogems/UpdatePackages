<?php
/**
 * @package YetiForce.actions
 * @license licenses/License.html
 * @author Mariusz Krzaczkowski <m.krzaczkowski@yetiforce.com>
 * @author Radosław Skrzypczak <r.skrzypczak@yetiforce.com>
 */
class Settings_WidgetsManagement_SaveAjax_Action extends Settings_Vtiger_IndexAjax_View
{

	function checkPermission(Vtiger_Request $request)
	{
		$currentUserModel = Users_Record_Model::getCurrentUserModel();
		$mode = $request->get('mode');
		if ($mode == 'delete' && !$currentUserModel->isAdminUser()) {
			throw new \Exception\AppException(vtranslate('LBL_PERMISSION_DENIED', 'Vtiger'));
		}
		$sourceModule = $request->get('sourceModule');
		$moduleModel = Vtiger_Module_Model::getInstance($sourceModule);
		$currentUserPriviligesModel = Users_Privileges_Model::getCurrentUserPrivilegesModel();
		if (!$currentUserPriviligesModel->hasModuleActionPermission($moduleModel->getId(), 'Save')) {
			throw new \Exception\AppException(vtranslate('LBL_PERMISSION_DENIED', 'Vtiger'));
		}
	}

	function __construct()
	{
		parent::__construct();
		$this->exposeMethod('save');
		$this->exposeMethod('delete');
	}

	public function save(Vtiger_Request $request)
	{
		$data = $request->get('form');
		$moduleName = $request->get('sourceModule');
		$addToUser = $request->get('addToUser');
		if (!is_array($data) || !$data) {
			$result = array('success' => false, 'message' => vtranslate('LBL_INVALID_DATA', $moduleName));
		} else {
			if (!$data['action'])
				$data['action'] = 'saveDetails';
			$action = $data['action'];
			$result = Settings_WidgetsManagement_Module_Model::$action($data, $moduleName, $addToUser);
		}
		$response = new Vtiger_Response();
		$response->setResult($result);
		$response->emit();
	}

	public function delete(Vtiger_Request $request)
	{
		$data = $request->get('form');
		$moduleName = $request->get('sourceModule');
		if (!is_array($data) || !$data) {
			$result = array('success' => false, 'message' => vtranslate('LBL_INVALID_DATA', $moduleName));
		} else {
			$action = $data['action'];
			if (!$action)
				$action = 'removeWidget';
			$result = Settings_WidgetsManagement_Module_Model::$action($data);
		}
		$response = new Vtiger_Response();
		$response->setResult($result);
		$response->emit();
	}
}
