package com.example.addmedicamento;

import androidx.appcompat.app.AppCompatActivity;

import android.app.DatePickerDialog;
import android.content.Intent;
import android.database.sqlite.SQLiteDatabase;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.AutoCompleteTextView;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;

import org.w3c.dom.Text;

import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class MainActivity extends AppCompatActivity {
    private ArrayList<TipoItem> mTipoList;
    private TipoAdapter mAdapter;
    private Button btnViewData;
    private static final String SAMPLE_DB_NAME = "TrekBook";
    private static final String SAMPLE_TABLE_NAME = "Info";
    //mostrar dados activity 2
    public static String Tipo;
    public static final String EXTRA_TEXT = "com.example.application.example.EXTRA_TEXT";
    public static final String EXTRA_TEXT2 = "com.example.application.example.EXTRA_TEXT2";
    ////
    DatabaseHelper mDatabaseHelper;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        mDatabaseHelper = new DatabaseHelper(this);
        //Seccao texto-> Nome do Medicamento

        initList();
        Spinner spinnerTipo = findViewById(R.id.spinner);
        mAdapter=new TipoAdapter(this,mTipoList);
        spinnerTipo.setAdapter(mAdapter);

        spinnerTipo.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                TipoItem clickedItem = (TipoItem) parent.getItemAtPosition(position);
                String clickedtiponame=clickedItem.getmTipoName();
                Tipo=clickedtiponame;
                Toast.makeText(MainActivity.this,clickedtiponame+ " selecionado",Toast.LENGTH_SHORT).show();
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });
        textautocomplete();

        //save/mostrar dados
        Button button = (Button) findViewById(R.id.button);
        final EditText editText1 = (EditText) findViewById(R.id.autoCompleteTextView);
        String text = editText1.getText().toString();

        Spinner editText2 = (Spinner) findViewById(R.id.spinner);
        final String text2 = Tipo;
        button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String newEntry = editText1.getText().toString();
                String newEntry2 = Tipo;
                if ((editText1.length() & Tipo.length())!= 0) {
                    AddData(newEntry, newEntry2);
                    editText1.setText("");

                } else {
                    toastMessage("You must put something in the text field!");
                }

                //openActivity2();
            }
        });
        //view data
        btnViewData = (Button) findViewById(R.id.btnView);
        btnViewData.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(MainActivity.this, ListDataActivity.class);
                startActivity(intent);
            }
        });



    }
    public void AddData(String newEntry,String newEntry2) {
        boolean insertData = mDatabaseHelper.addData(newEntry,newEntry2);

        if (insertData) {
            toastMessage("Data Successfully Inserted!");
        } else {
            toastMessage("Something went wrong");
        }
    }

    /**
     * customizable toast
     * @param message
     */
    private void toastMessage(String message){
        Toast.makeText(this,message, Toast.LENGTH_SHORT).show();
    }
    private void textautocomplete() {
        AutoCompleteTextView itemcodetextview = (AutoCompleteTextView) findViewById(R.id.autoCompleteTextView);
        Scanner scanner = new Scanner(getResources().openRawResource(R.raw.lista));
        List<String> listbatchnumbers = new ArrayList<String>();
        while (scanner.hasNext()) {
            listbatchnumbers.add(scanner.nextLine());
        }
        ArrayAdapter<String> adapter = new ArrayAdapter<String>(this, android.R.layout.simple_list_item_1, listbatchnumbers );
        itemcodetextview.setAdapter(adapter);
        scanner.close();
    }

    private void initList() {
        mTipoList = new ArrayList<>();
        mTipoList.add(new TipoItem("Capsula",R.drawable.capsula));
        mTipoList.add(new TipoItem("Colher de sopa",R.drawable.colherdesopa));
        mTipoList.add(new TipoItem("Colher de chá",R.drawable.colherdecha));
    }

    public void openActivity2() {
        EditText editText1 = (EditText) findViewById(R.id.autoCompleteTextView);
        String text = editText1.getText().toString();

        Spinner editText2 = (Spinner) findViewById(R.id.spinner);
        String text2 = Tipo;

        Intent intent = new Intent(this, Activity2.class);
        intent.putExtra(EXTRA_TEXT, text);
        intent.putExtra(EXTRA_TEXT2, text2);
        startActivity(intent);
    }
}
