package com.example.addmedicamento;

public class TipoItem {
    private String mTipoName;
    private int mTipoImage;

    public TipoItem(String TipoName, int TipoImage) {

        mTipoName = TipoName;
        mTipoImage = TipoImage;
    }
    public String getmTipoName() {
        return mTipoName;
    }

    public int getmTipoImage() {
        return mTipoImage;
    }



}
