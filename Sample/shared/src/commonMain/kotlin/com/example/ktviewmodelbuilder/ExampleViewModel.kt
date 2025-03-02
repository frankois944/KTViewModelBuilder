package com.example.ktviewmodelbuilder

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch

public data class MyData(
    val stringData: String = "Some Data",
    val intNullableData: Int? = null,
    val randomValue: Int = 0,
    val entityData: String = "Some Data"
)

public class ExampleViewModel : ViewModel() {

    public var bidirectionalString: MutableStateFlow<String> = MutableStateFlow<String>("SOME INPUT")
    public var bidirectionalBoolean: MutableStateFlow<Boolean> = MutableStateFlow<Boolean>(false)
    public var bidirectionalInt: MutableStateFlow<Int?> = MutableStateFlow<Int?>(42)
    public var bidirectionalLong: MutableStateFlow<Long> = MutableStateFlow<Long>(424242L)
    public var bidirectionalArrayString: MutableStateFlow<List<String>> = MutableStateFlow<List<String>>(emptyList())
    
    private val _stringData = MutableStateFlow("Some Data")
    public val stringData: StateFlow<String> = _stringData

    private val _listStringData = MutableStateFlow<List<String>>(emptyList())
    public val listStringData: StateFlow<List<String>> = _listStringData
    
    private val _listNullStringData = MutableStateFlow<List<String>?>(emptyList())
    public val listNullStringData: StateFlow<List<String>?> = _listNullStringData

    private val _listIntData = MutableStateFlow<List<Int>>(emptyList())
    public val listIntData: StateFlow<List<Int>> = _listIntData

    private val _intNullableData = MutableStateFlow<Int?>(null)
    public val intNullableData: StateFlow<Int?> = _intNullableData

    private val _randomValue = MutableStateFlow(0)
    public val randomValue: StateFlow<Int> = _randomValue

    private val _entityData = MutableStateFlow<MyData?>(MyData())
    public val entityData: StateFlow<MyData?> = _entityData

    public fun randomizeValue() {
        _randomValue.value = (0..100).random()
    }

    init {
        viewModelScope.launch {
            bidirectionalString.collect {
                println("COLLECT bidirectionalString $it")
            }
        }
        viewModelScope.launch {
            bidirectionalBoolean.collect {
                println("COLLECT bidirectionalBoolean $it")
            }
        }
        viewModelScope.launch {
            bidirectionalInt.collect {
                println("COLLECT bidirectionalInt $it")
            }
        }
        viewModelScope.launch {
            bidirectionalLong.collect {
                println("COLLECT bidirectionalLong $it")
            }
        }
    }
}
