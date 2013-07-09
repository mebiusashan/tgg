#TGG Format File


##What's the TGG format file?

TGG格式是一种树状结构数据。

##TGG Format File Data

###Header部分
	数据头
	TGG          4字节 uint 0x544747 "TGG"的ASCII编码
	version      2字节 int     1      版本，当前为1

	节点数据段
	type         2字节 int     0      始终为0，表示当前数据为节点数据段
	index_pos    4字节 uint    22     节点数据起始编号，使用为22
	num block    4字节 uint    n      节点数据块个数，uint最大值为4294967295

	节点属性数据段
	type         2字节 uint    1      始终为1，表示当前数据为节点属性数据段
	index_pos    4字节 uint    n      节点属性数据段的起始点

###节点索引数据块
	ID           4字节 uint    n      对应文件的ID,ID唯一
	parent       4字节 uint    n      父节点ID，32位无符号
	data_pos     4字节 uint    n      对应数据的起始点

###实际数据段
	length       4字节 uint    n      当前数据段长度
	数据段
	key          n字节 str UTF-8    n      键
	value        n字节 str UTF-8    n      键值

	demo（以冒号和分好区隔）
	key:value;key:value
