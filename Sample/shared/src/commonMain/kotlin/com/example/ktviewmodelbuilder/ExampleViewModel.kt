package com.example.ktviewmodelbuilder

import androidx.lifecycle.ViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow

public data class MyData(
    val stringData: String = "Some Data",
    val intNullableData: Int? = null,
    val randomValue: Int = 0,
    val entityData: String = "Some Data"
)

public class ExampleViewModel : ViewModel() {

    private val _stringData = MutableStateFlow("Some Data")
    public val stringData: StateFlow<String> = _stringData

    private val _intNullableData = MutableStateFlow<Int?>(null)
    public val intNullableData: StateFlow<Int?> = _intNullableData

    private val _randomValue = MutableStateFlow(0)
    public val randomValue: StateFlow<Int> = _randomValue

    private val _entityData = MutableStateFlow<MyData?>(MyData())
    public val entityData: StateFlow<MyData?> = _entityData

    public fun randomizeValue() {
        _randomValue.value = (0..100).random()
    }
}