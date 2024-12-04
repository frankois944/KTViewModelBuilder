package com.example.ktviewmodelbuilder.android

import androidx.compose.foundation.layout.Column
import androidx.compose.material3.Button
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.example.ktviewmodelbuilder.ExampleViewModel
import androidx.lifecycle.viewmodel.compose.viewModel

@Composable
fun ExampleScreen(modifier: Modifier = Modifier, viewModel: ExampleViewModel = viewModel()) {
    val stringData = viewModel.stringData.collectAsStateWithLifecycle()
    val intNullableData = viewModel.intNullableData.collectAsStateWithLifecycle()
    val randomValue = viewModel.randomValue.collectAsStateWithLifecycle()

    Column(modifier = modifier) {
        Text(text = "STRING VALUE " + stringData.value)
        Text(text = "NULL VALUE " + intNullableData.value.toString())
        Text(text = "RANDOM VALUE " + randomValue.value.toString())

        Button(onClick = { viewModel.randomizeValue()} ) {
            Text(text = "Randomize")
        }
    }
}

@Preview(showBackground = true)
@Composable
private fun ExamplePreviewScreen() {
    Surface {
        ExampleScreen(viewModel = ExampleViewModel())
    }
}