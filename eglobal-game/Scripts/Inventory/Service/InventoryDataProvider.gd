class_name InventoryDataProvider

func create_view_model(model:InventoryItemModel) -> InventoryItemViewModel:
	var viewModel: InventoryItemViewModel = InventoryItemViewModel.new()
	viewModel.itemName = model.itemName
	return viewModel