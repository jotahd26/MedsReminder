package com.example.addmedicamento;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.Toast;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import java.util.ArrayList;

/**
 * Created by User on 2/28/2017.
 */

public class EditDataActivity extends AppCompatActivity {
    private ArrayList<TipoItem> mTipoList;
    private TipoAdapter mAdapter;
    private static final String TAG = "EditDataActivity";

    private Button btnSave,btnDelete;
    private EditText editable_item;

    DatabaseHelper mDatabaseHelper;

    private String selectedName;
    private String selectedTipo;
    private int selectedID;
    public static String Tipo;
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.edit_data_layout);
        btnSave = (Button) findViewById(R.id.btnSave);
        btnDelete = (Button) findViewById(R.id.btnDelete);
        editable_item = (EditText) findViewById(R.id.editable_item);
        initList();
        mDatabaseHelper = new DatabaseHelper(this);
        Spinner spinnerTipo = findViewById(R.id.spinner);
        mAdapter=new TipoAdapter(this,mTipoList);
        spinnerTipo.setAdapter(mAdapter);

        spinnerTipo.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                TipoItem clickedItem = (TipoItem) parent.getItemAtPosition(position);
                String clickedtiponame=clickedItem.getmTipoName();
                Tipo=clickedtiponame;
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });
        //get the intent extra from the ListDataActivity
        Intent receivedIntent = getIntent();

        //now get the itemID we passed as an extra
        selectedID = receivedIntent.getIntExtra("id",-1); //NOTE: -1 is just the default value

        //now get the name we passed as an extra
        selectedName = receivedIntent.getStringExtra("nome");
        //selectedTipo = receivedIntent.getStringExtra("tipo");

        //set the text to show the current selected name
        editable_item.setText(selectedName);

        btnSave.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                String item = editable_item.getText().toString();
                if(!item.equals("")){
                    mDatabaseHelper.updateName(item,selectedID);
                    mDatabaseHelper.updateTipo(Tipo,selectedID);
                    toastMessage("update successful!");
                }else{
                    toastMessage("You must enter a name");
                }
            }
        });

        btnDelete.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                mDatabaseHelper.deletebyId(selectedID);
                editable_item.setText("");
                toastMessage("removed from database");
            }
        });

    }

    /**
     * customizable toast
     * @param message
     */
    private void toastMessage(String message){
        Toast.makeText(this,message, Toast.LENGTH_SHORT).show();
    }
    private void initList() {
        mTipoList = new ArrayList<>();
        mTipoList.add(new TipoItem("Capsula",R.drawable.capsula));
        mTipoList.add(new TipoItem("Colher de sopa",R.drawable.colherdesopa));
        mTipoList.add(new TipoItem("Colher de chá",R.drawable.colherdecha));
    }
}
























